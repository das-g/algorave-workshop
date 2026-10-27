Tidal Cycles
===

[Tidal Cycles](https://tidalcycles.org/) is a live coding language for music
written in haskell, created by Alan Hickey. 

<!-- new_lines: 1 -->

# How does it work?

<!-- new_lines: 1 -->

_Patterns_ are evaluated on numbered tracks (`d1`, `d2`, ...). Each pattern loops
forever (_cycle_) and is sent to the _sound engine_:

<!-- new_lines: 1 -->

```haskell
d1 $ jux rev $ speed "<1 0.5 0.75>(<3 5>,8)" # sound "bev" 
    # cut 1 # room 0.4 # sz 0.9 # gain 1.3

d2 $ sound "[bd - sd - - bd sd -], hh*8, [- hh]*2"
```

<!-- new_lines: 1 -->

> To hear sound, the sound engine `superdirt-start` must be running (see the README).

Strudel
===

[Strudel](https://strudel.cc) is the modern successor to Tidal Cycles:

<!-- new_lines: 1 -->

- Simlar pattern language, upgraded audio engine
- Runs entirely in your browser

```bash +exec_replace +no_background
echo https://strudel.cc | qrencode -t utf8i
```

Pattern Building blocks
===

```javascript
[0 2]       // sequence: one step at a time
[0, 2]      // parallel: both in the same step
[0 2]!2     // repeat
[0 2]@2     // elongate
[0 2]*2     // faster
[0 2]/2     // slower
<0 2>       // alternate
:5          // sample number 5
- or ~      // rest
```

Notes
===

Two ways of writing:
```javascript
$: note("48 52 55 59").sound("piano")
// ==
$: note("c e g b").sound("piano")
```

<!-- pause -->
Change sound
```javascript
$: note("c e g b").sound("gm_accordion")
```

<!-- pause -->
Everything can be a pattern!
```javascript
$: n("<0 -3>, 2 4 <[6,8] [7,9]>")
    .scale("<C:major D:mixolydian>/4")
    .sound("<piano sine>")
```

Musical scales
===

`n` plays scale degrees. It does the music theory for you!

<!-- new_lines: 1 -->

```javascript
$: n("[0 [~ 0] 4 [3 2] [0 ~] [0 ~] <0 2> ~]/2")
  .scale("D2:minor")

$: s("[bd - sd - - bd sd -], hh*8, [- oh]*2").bank("RolandTR909")
```

Effects
===

Chain as many as you like

```javascript
$: note("[~ [<[d3,a3,f4]!2 [d3,bb3,g4]!2> ~]]*2")
  .sound("gm_electric_guitar_muted")
  .attack(.1)
  .sustain(.5)
  .decay(.4)
  .release(.2)
  .delay(.5)
  .room(.4)
  .lpf(300)
```

Go bigger
===

Mute patterns by appending an underscore `_` to the dollar `$`
```javascript
$_: sound("[bd - bd hh]")
```

Multiline patterns can be put in backticks ``

```javascript
$: sound(`
    [-  -  -  - ] [-  -  -  oh],
    [hh hh -  hh] [hh hh hh hh],
    [-  -  cp - ] [-  -  cp - ],
    [bd -  -  - ] [-  bd -  bd]
`)
```

You can write js code to modularize your set

```javascript
const guitarSound = "gm_electric_guitar_clean:9"
const mainADSR = "0:.5:.4:.2"
const scale = "D:Dorian"

$: n("[<0 -1> [~ <0 1>] ~ <3 2>]").scale(scale)
    .sound(guitarSound).adsr(mainADSR)
$: n("<[2@7 4] <1 3>>").scale(scale)
    .sound(guitarSound).adsr(mainADSR)
```

Our example song
===

`example/example.strudel`

```javascript
$: note("[~ [<[d3,a3,f4]!2 [d3,bb3,g4]!2> ~]]*2")
  .sound("gm_electric_guitar_muted").delay(.5)

$: sound("bd rim").bank("RolandTR707").delay(.5)

$: n("<4 [3@3 4] [<2 0> ~@16] ~>")
  .scale("D4:minor").sound("gm_accordion:2")
  .room(2).gain(.4)

$: n("[0 [~ 0] 4 [3 2] [0 ~] [0 ~] <0 2> ~]/2")
  .scale("D2:minor")
  .sound("sawtooth,triangle").lpf(200)
```

Four channels: guitar, drums, melody, bass.
