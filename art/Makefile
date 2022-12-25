
TARGET := ../game/assets/
NORMAL_SCRIPT := C:/Users/rluis/AppData/Roaming/Aseprite/scripts/securas/basic_edge_normal.lua
.PHONY = all

ifeq ($(OS),Windows_NT)
	ASEPRITE := C:/Program Files (x86)/Steam/steamapps/common/Aseprite/Aseprite.exe
else
	# this is only for my compiled version of aseprite on Mac OSX
	ASEPRITE := /Applications/Aseprite/aseprite
endif

all: \
	$(TARGET)player.png \
	$(TARGET)player_dust.png \
	$(TARGET)tileset.png \
	$(TARGET)enemies.png \
	$(TARGET)explosion_16px.png \
	$(TARGET)explosion_24px.png \
	$(TARGET)explosion_32px.png \
	$(TARGET)hud.png \

$(TARGET)player.png: player.aseprite
	$(ASEPRITE) -b player.aseprite -sheet $(TARGET)player.png --sheet-width 64 --sheet-height 80
	$(ASEPRITE) -b $(TARGET)player.png --script $(NORMAL_SCRIPT) --save-as $(TARGET)player_normal.png

$(TARGET)player_dust.png: player_dust.aseprite
	$(ASEPRITE) -b player_dust.aseprite -sheet $(TARGET)player_dust.png --sheet-width 64

$(TARGET)enemies.png: enemies.aseprite
	$(ASEPRITE) -b enemies.aseprite -sheet $(TARGET)enemies.png --sheet-width 64
	$(ASEPRITE) -b $(TARGET)enemies.png --script $(NORMAL_SCRIPT) --save-as $(TARGET)enemies_normal.png

$(TARGET)tileset.png: tileset.aseprite
	$(ASEPRITE) -b tileset.aseprite --save-as $(TARGET)tileset.png

$(TARGET)explosion_16px.png: explosion_16px.aseprite
	$(ASEPRITE) -b explosion_16px.aseprite -sheet $(TARGET)explosion_16px.png --sheet-width 192 --sheet-height 24

$(TARGET)explosion_24px.png: explosion_24px.aseprite
	$(ASEPRITE) -b explosion_24px.aseprite -sheet $(TARGET)explosion_24px.png --sheet-width 320 --sheet-height 40

$(TARGET)explosion_32px.png: explosion_32px.aseprite
	$(ASEPRITE) -b explosion_32px.aseprite -sheet $(TARGET)explosion_32px.png --sheet-width 512 --sheet-height 64

$(TARGET)hud.png: hud.aseprite
	$(ASEPRITE) -b hud.aseprite --save-as $(TARGET)hud.png
