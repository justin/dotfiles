#!/usr/bin/env python3
"""Import and export Xcode 27 recipe themes as JSON.

Xcode 27 stores theme recipes as UTF-8 JSON data blobs in the
``com.apple.dt.Xcode`` preferences domain. This tool changes only those keys
needed for the requested operation.

Running the same import again is a no-op: a preference is written only when
its decoded JSON differs from the desired value. ``--new-id`` is intentionally
the exception, because it explicitly requests a new recipe on every run.

Usage:
    xcode27_theme.py list
    xcode27_theme.py export <name-or-id> <out.json> [--font] [--settings]
    xcode27_theme.py export --all <out.json>
    xcode27_theme.py import <in.json> [--activate {light,dark,both}]
                                      [--rename NAME] [--new-id] [--no-font]

Quit Xcode before importing. Restart it after a changed import.
"""

from __future__ import annotations

import argparse
import getpass
import hashlib
import json
import plistlib
import subprocess
import sys
import uuid
from collections.abc import Mapping
from datetime import datetime
from pathlib import Path
from typing import Any

Recipe = dict[str, Any]
Preferences = dict[str, Any]

DOMAIN = "com.apple.dt.Xcode"
KEY_SETTINGS = "DVTWorkspaceThemeSettings"
KEY_RECIPES = "DVTWorkspaceSavedRecipes"
KEY_FONT = "DVTWorkspaceGlobalFontRecipe"
BUNDLE_FORMAT = "xcode-theme-bundle"
BUNDLE_VERSION = 1
CF_EPOCH = 978307200.0


def read_preferences() -> Preferences:
    """Read the Xcode preferences domain."""
    return plistlib.loads(subprocess.check_output(["defaults", "export", DOMAIN, "-"]))


def read_json_key(preferences: Preferences, key: str) -> Any:
    """Decode a JSON data-blob preference, returning None when absent."""
    value = preferences.get(key)
    if value is None:
        return None
    if not isinstance(value, (bytes, bytearray)):
        raise TypeError(f"{key} is {type(value).__name__}, not a data blob")
    return json.loads(bytes(value).decode("utf-8"))


def write_json_key(key: str, value: Any) -> None:
    """Write a compact JSON value as a data-blob preference."""
    data = json.dumps(value, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
    subprocess.run(["defaults", "write", DOMAIN, key, "-data", data.hex()], check=True)


def write_json_key_if_changed(key: str, current: Any, desired: Any) -> bool:
    """Write *desired* only when it differs from *current*."""
    if current == desired:
        return False
    write_json_key(key, desired)
    return True


def flush_preferences() -> None:
    """Best-effort flush of cfprefsd after an actual preference change."""
    subprocess.run(["killall", "-u", getpass.getuser(), "cfprefsd"], stderr=subprocess.DEVNULL)


def recipes_from(preferences: Preferences) -> list[Recipe]:
    """Return saved recipes, treating a missing or malformed value as empty."""
    value = read_json_key(preferences, KEY_RECIPES)
    return value if isinstance(value, list) else []


def find_recipe(recipes: list[Recipe], name_or_id: str) -> Recipe | None:
    """Find a recipe by ID, exact name, then unambiguous folded name."""
    for recipe in recipes:
        if recipe.get("id") == name_or_id or recipe.get("name") == name_or_id:
            return recipe
    matches = [
        recipe for recipe in recipes
        if isinstance(recipe.get("name"), str)
        and recipe["name"].casefold() == name_or_id.casefold()
    ]
    return matches[0] if len(matches) == 1 else None


def active_map(settings: Any) -> dict[str, list[str]]:
    """Return recipe IDs mapped to appearances in which they are active."""
    if not isinstance(settings, Mapping):
        return {}
    result: dict[str, list[str]] = {}
    for appearance, choice in settings.items():
        if not isinstance(choice, Mapping):
            continue
        saved = choice.get("savedRecipe")
        recipe_id = saved.get("_0") if isinstance(saved, Mapping) else None
        if isinstance(recipe_id, str):
            result.setdefault(recipe_id, []).append(str(appearance))
    return result


def format_date(cf_time: Any) -> str:
    if not isinstance(cf_time, (int, float)):
        return ""
    return datetime.fromtimestamp(cf_time + CF_EPOCH).strftime("%Y-%m-%d %H:%M")


def command_list(_args: argparse.Namespace) -> None:
    preferences = read_preferences()
    recipes = recipes_from(preferences)
    if not recipes:
        print("No saved recipes.")
        return
    active = active_map(read_json_key(preferences, KEY_SETTINGS))
    name_width = max(4, *(len(str(recipe.get("name", ""))) for recipe in recipes))
    print(f"{'NAME':<{name_width}}  {'ID':<36}  {'ACTIVE':<10}  LAST USED")
    for recipe in recipes:
        recipe_id = str(recipe.get("id", ""))
        appearances = ",".join(active.get(recipe_id, [])) or "-"
        print(f"{str(recipe.get('name', '')):<{name_width}}  {recipe_id:<36}  "
              f"{appearances:<10}  {format_date(recipe.get('lastUsedDate'))}")


def command_export(args: argparse.Namespace) -> None:
    preferences = read_preferences()
    bundle: dict[str, Any] = {"format": BUNDLE_FORMAT, "version": BUNDLE_VERSION, "recipes": []}
    if args.all:
        bundle["recipes"] = recipes_from(preferences)
        bundle["fontRecipe"] = read_json_key(preferences, KEY_FONT)
        bundle["themeSettings"] = read_json_key(preferences, KEY_SETTINGS)
    else:
        recipe = find_recipe(recipes_from(preferences), args.name)
        if recipe is None:
            raise SystemExit(f"export: no recipe matching {args.name!r} (try `{sys.argv[0]} list`)")
        bundle["recipes"] = [recipe]
        if args.font:
            bundle["fontRecipe"] = read_json_key(preferences, KEY_FONT)
        if args.settings:
            bundle["themeSettings"] = read_json_key(preferences, KEY_SETTINGS)
    with Path(args.out).open("w", encoding="utf-8") as file:
        json.dump(bundle, file, ensure_ascii=False, indent=2)
        file.write("\n")
    print(f"Exported {len(bundle['recipes'])} recipe(s) to {args.out}")


def recipe_id_for(workspace_recipe: Mapping[str, Any]) -> str:
    """Return a stable ID for a native .xcworkspacecolortheme recipe."""
    canonical = json.dumps(workspace_recipe, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    digest = hashlib.sha256(canonical.encode("utf-8")).hexdigest()
    return str(uuid.uuid5(uuid.NAMESPACE_URL, f"com.justinwilliams.xcode27-theme:{digest}")).upper()


def normalize_incoming(bundle: Any) -> list[Recipe]:
    """Accept a bundle, recipe array, saved recipe, or native workspace theme."""
    if isinstance(bundle, dict) and "recipes" in bundle:
        recipes = bundle["recipes"]
    elif isinstance(bundle, list):
        recipes = bundle
    elif isinstance(bundle, dict) and isinstance(bundle.get("recipe"), Mapping):
        recipe = dict(bundle)
        recipe.pop("fileVersion", None)
        recipe.setdefault("id", recipe_id_for(bundle["recipe"]))
        recipes = [recipe]
    else:
        raise SystemExit("import: unrecognized JSON shape")
    if not isinstance(recipes, list) or not all(isinstance(recipe, dict) for recipe in recipes):
        raise SystemExit("import: recipes must be an array of objects")
    return [recipe.copy() for recipe in recipes]


def merge_recipes(current: list[Recipe], incoming: list[Recipe]) -> tuple[list[Recipe], int, int]:
    """Return desired recipes and counts of added and replaced recipes."""
    merged = current.copy()
    index_by_id = {recipe.get("id"): index for index, recipe in enumerate(merged)}
    added = replaced = 0
    for recipe in incoming:
        recipe_id = recipe.get("id")
        if recipe_id in index_by_id:
            index = index_by_id[recipe_id]
            if merged[index] != recipe:
                merged[index] = recipe
                replaced += 1
        else:
            merged.append(recipe)
            index_by_id[recipe_id] = len(merged) - 1
            added += 1
    return merged, added, replaced


def activate_recipe(settings: Any, recipe_id: str, appearances: list[str]) -> dict[str, Any]:
    """Return settings with *recipe_id* selected, preserving other fields."""
    updated = dict(settings) if isinstance(settings, Mapping) else {}
    for appearance in appearances:
        choice = updated.get(appearance)
        updated_choice = dict(choice) if isinstance(choice, Mapping) else {}
        saved = updated_choice.get("savedRecipe")
        updated_saved = dict(saved) if isinstance(saved, Mapping) else {}
        updated_saved["_0"] = recipe_id
        updated_choice["savedRecipe"] = updated_saved
        updated[appearance] = updated_choice
    return updated


def command_import(args: argparse.Namespace) -> None:
    with Path(args.infile).open(encoding="utf-8") as file:
        bundle = json.load(file)
    incoming = normalize_incoming(bundle)
    if not incoming:
        raise SystemExit("import: no recipes found in file")
    if args.rename:
        if len(incoming) != 1:
            raise SystemExit("import: --rename only works with a single-recipe file")
        incoming[0]["name"] = args.rename
    if args.new_id:
        for recipe in incoming:
            recipe["id"] = str(uuid.uuid4()).upper()
    preferences = read_preferences()
    current_recipes = recipes_from(preferences)
    desired_recipes, added, replaced = merge_recipes(current_recipes, incoming)
    changed_keys: list[str] = []
    if write_json_key_if_changed(KEY_RECIPES, current_recipes, desired_recipes):
        changed_keys.append(KEY_RECIPES)
    if bundle.get("fontRecipe") is not None and not args.no_font:
        current_font = read_json_key(preferences, KEY_FONT)
        if write_json_key_if_changed(KEY_FONT, current_font, bundle["fontRecipe"]):
            changed_keys.append(KEY_FONT)
    if args.activate:
        current_settings = read_json_key(preferences, KEY_SETTINGS)
        appearances = ["light", "dark"] if args.activate == "both" else [args.activate]
        desired_settings = activate_recipe(current_settings, incoming[0]["id"], appearances)
        if write_json_key_if_changed(KEY_SETTINGS, current_settings, desired_settings):
            changed_keys.append(KEY_SETTINGS)
    if changed_keys:
        flush_preferences()
        message = f"Imported: {added} added, {replaced} replaced"
        if args.activate:
            message += f"; activated {incoming[0].get('name', '')!r} for {args.activate}"
        print(message)
        print("Restart Xcode to pick up the change.")


def main(argv: list[str] | None = None) -> None:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    subparsers = parser.add_subparsers(dest="cmd", required=True)
    subparsers.add_parser("list", help="list saved recipes").set_defaults(func=command_list)
    export_parser = subparsers.add_parser("export", help="export recipe(s) to JSON")
    export_parser.add_argument("name", nargs="?", help="recipe name or ID")
    export_parser.add_argument("out", help="output JSON path")
    export_parser.add_argument("--all", action="store_true", help="export every recipe")
    export_parser.add_argument("--font", action="store_true", help="include global font")
    export_parser.add_argument("--settings", action="store_true", help="include theme settings")
    export_parser.set_defaults(func=command_export)
    import_parser = subparsers.add_parser("import", help="import recipe(s) from JSON")
    import_parser.add_argument("infile", help="input JSON path")
    import_parser.add_argument("--activate", choices=["light", "dark", "both"])
    import_parser.add_argument("--rename", help="rename one imported recipe")
    import_parser.add_argument("--new-id", action="store_true", help="assign fresh UUIDs")
    import_parser.add_argument("--no-font", action="store_true", help="do not import font")
    import_parser.set_defaults(func=command_import)
    args = parser.parse_args(argv)
    if args.cmd == "export" and not args.all and not args.name:
        parser.error("export requires <name-or-id>, or --all")
    try:
        args.func(args)
    except subprocess.CalledProcessError as error:
        raise SystemExit(f"defaults command failed: {error}") from error


if __name__ == "__main__":
    main()
