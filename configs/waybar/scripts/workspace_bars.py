#!/usr/bin/env python3
import json
import subprocess

def get_workspaces():
    try:
        raw = subprocess.check_output(["hyprctl", "workspaces", "-j"])
        return json.loads(raw)
    except Exception as e:
        return []

def main():
    workspaces = get_workspaces()

    # Build output with bars for each workspace
    output = []
    for ws in workspaces:
        id = ws.get("id", 0)
        focused = ws.get("focused", False)
        bars = "|" * id if id > 0 else ""
        if focused:
            # Wrap active workspace bars in bold tags (Pango markup)
            bars = f"<b>{bars}</b>"
        output.append(bars)

    # Join all workspace bars with spaces (or any separator)
    print(json.dumps({"text": " ".join(output)}))

if __name__ == "__main__":
    main()
