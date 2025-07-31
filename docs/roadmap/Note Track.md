#mvp

Note track is simply the display that shows the notes for players to hit. For a full gameplay loop, add [[MIDI handler]].
# Layout
A piano will be used to prompt what notes the player should hit
- [x] Render Piano keys
- [x] ID Piano keys
- [ ] Measure lines (optional feature)
# Falling notes
- [x] Render notes that fall to the right key
- [ ] Dynamic note size relative to MIDI note duration
- [x] Sync to audio (Optional addition)
# Additional information
## Implemention
Note track is implemented as

And uses
## References
Note Track uses [[Dependencies#arlez80 godot-midi-player]]