@import "~/.config/rofi/wallust/colors-rofi.rasi"

configuration {
    show-icons: true;
    hover-select: true;
    me-select-entry: "MouseSecondary";
    me-accept-entry: "MousePrimary";
    dpi: 1;
}

* {
    background:                  transparent;
    background-alt:              @alternate-active-background;
    selected:                    @selected-normal-foreground;
    active:                      @selected-urgent-foreground;
    urgent:                      @urgent-background;
    text-selected:               @foreground;
    text-color:                  @foreground;
    border-color:                @selected-normal-background;
}

window {
    background-color: @background;
    border: 2px;
    border-color: @border-color;
    border-radius: 12px;
    width: 90%;
    height: inherit;
    location: center;
    anchor: center;
    padding: 15px;
}

mainbox {
    children: [ "listview" ];
    background-color: transparent;
    spacing: 2px;
}

listview {
    columns: 7; 
    lines: 1;  
    dynamic: true;
    scrollbar: true;
    layout: vertical;
    spacing: 15px;
    padding: 10px;
    background-color: transparent;
}

element {
    orientation: vertical;
    spacing: 2px;
    padding: 5px;
    border-radius: 8px;
    background-color: transparent; 
    cursor: pointer;
    width: 200px;
    height: 200px;
}

element normal.normal {
    background-color: transparent;
    text-color: @foreground;
}

element selected.normal {
    background-color: @selected-normal-background;
    text-color: @selected-normal-foreground;
    border: 2px;
    border-color: @border-color;
}

element-icon {
    size: 200px; 
    border-radius: 6px;
    horizontal-align: 0.5;
    background-color: transparent;
}

element-text {
    text-align: center;
    font-size: 11px;
    vertical-align: 0.5;
    background-color: transparent;
    horizontal-align: 0.5;
    wrap: true;
    max-width: 190px;
    color: @text-color;
}

inputbar {
    enabled: false;
}

message {
    enabled: false;
}
