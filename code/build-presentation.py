#!/usr/bin/env python3
"""Build the standalone HTML version of the club presentation (Claude Slides deck).

The Claude Slides artifact is the source of truth; this script turns an export
of its files into a static page served on guide.balan-running.fr/presentation/.

Usage (from the repo root):
    python3 code/build-presentation.py DECK_DIR [OUT_DIR]

DECK_DIR  folder holding the artifact files `deck.json` and `slides/*.html`
          (the `project/` folder of the Slides artifact).
OUT_DIR   output folder (default: presentation). Images are read from
          OUT_DIR/images (or from DECK_DIR/../assets if present) and must be
          named as in BLOBS below.

Then render the guide (Quarto copies presentation/ into docs/ via `resources`),
or copy presentation/ into docs/presentation/ directly.

Speaker notes (<aside>) are dropped: the page is public.
"""
import json, re, shutil, sys
from pathlib import Path

DECK = Path(sys.argv[1])
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("presentation")

# artifact asset id (/_blob/<id>) -> image file name
BLOBS = {
    "ceea963411974d778208cd04747379b1": "intervals-forme2.png",
    "747eef17c14218169dd09fab47430cb9": "intervals-forme.png",
    "47878551ffbd6dd6ddb9fbc1c91402d2": "fig-volume.png",
    "254d8dc34a8ff1fb5a84c403e0267422": "fig-ef.png",
    "faf3fe44593c0fb677a6484914f98314": "fig-vma-seuil.png",
    "063b4881f85aa2fff888130ff33c1521": "logo.png",
    "260f4b4fd84435026bcfc54c405f324e": "montre-ecran1.png",
    "cf46d893c5d1844d12d717ed41d59e0a": "montre-ecran2.png",
    "bbaffa991863fc81c442f145f10918e8": "montre-ecran3.png",
    "f0d4fe46dd11cbd03c86bbb6a2a383f5": "jj.png",
    "2976c3971611eb612a15e4e1cbb77cbc": "lionel.png",
    "aa9c45adb8abfc1208a5b611a7a22825": "laurent.png",
    "2e886f807bcbd157a7d84cc6be40925b": "frederic.png",
    "d8ee2c57f4beb518e9e525db1c80f584": "vincent.png",
    "4652d9ccd662f51dd8278e037628cfdc": "florian.png",
    "2514851456848f45b9ef6c7622ee865c": "qr-guide.png",
    "22d97f464a4afe6d6c0c3f833bf0054f": "fig-ef.png",
    "ed3c8608953a78e39a5286f3473d9a4c": "fig-volume.png",
    "9909670c97a13e53a3a7f5a79170be70": "fig-vma-seuil.png",
    "4d6144de798ec8c1f5f9f34ae5de7a33": "fig-ef.png",
    "32488966273a896b30a92c0b45f168c6": "fig-volume.png",
    "979baf13c754e1c26449c26462e70866": "fig-vma-seuil.png",
    "8fb6e6f69b44a25f4cb38c4d4df3e019": "logo-negatif.png",
    "2e4b6dd472295d5cf6805f63b37f7ed0": "montre-rond1.png",
    "2aaa2aa342cbf1922a34937f78c0040c": "montre-rond2.png",
    "452d41879d8269d69908d0d76bc6225f": "montre-rond3.png",
}

# Phosphor icons (MIT, bold weight) replacing the Slides <x-icon> set
ICONS = {
    "Activity": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M71.76,148H31.7a12,12,0,1,1,0-24H65.33l12.45-18.66a12,12,0,0,1,20,0l22,33,6-9a12,12,0,0,1,10-5.34h24a12,12,0,1,1,0,24h-17.6l-12.46,18.66a12,12,0,0,1-20,0l-22-33-6,9A12,12,0,0,1,71.76,148ZM177.91,36c-20.12,0-38,7.93-50.07,21.56C115.74,43.93,97.89,36,77.76,36A66,66,0,0,0,12.07,94.68,12,12,0,0,0,36,97.32,42,42,0,0,1,77.76,60c17.83,0,32.75,9.4,38.95,24.54a12,12,0,0,0,22.25,0C145.16,69.4,160.08,60,177.91,60A42.08,42.08,0,0,1,220,102c0,29.42-25.86,57.77-47.56,76.36a329,329,0,0,1-44.58,31.81c-10.87-6.45-35.37-22-56.51-42.73a12,12,0,1,0-16.84,17.12c30.39,29.81,66.15,49.2,67.66,50a12.06,12.06,0,0,0,11.39,0C138,232.14,244,174.34,244,102A66.12,66.12,0,0,0,177.91,36Z"/></svg>',
    "Clock": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M128,20A108,108,0,1,0,236,128,108.12,108.12,0,0,0,128,20Zm0,192a84,84,0,1,1,84-84A84.09,84.09,0,0,1,128,212Zm68-84a12,12,0,0,1-12,12H128a12,12,0,0,1-12-12V72a12,12,0,0,1,24,0v44h44A12,12,0,0,1,196,128Z"/></svg>',
    "Lightning": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M219.71,117.38a12,12,0,0,0-7.25-8.52L161.28,88.39l10.59-70.61a12,12,0,0,0-20.64-10l-112,120a12,12,0,0,0,4.31,19.33l51.18,20.47L84.13,238.22a12,12,0,0,0,20.64,10l112-120A12,12,0,0,0,219.71,117.38ZM113.6,203.55l6.27-41.77a12,12,0,0,0-7.41-12.92L68.74,131.37,142.4,52.45l-6.27,41.77a12,12,0,0,0,7.41,12.92l43.72,17.49Z"/></svg>',
    "Link": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M117.18,188.74a12,12,0,0,1,0,17l-5.12,5.12A58.26,58.26,0,0,1,70.6,228h0A58.62,58.62,0,0,1,29.14,127.92L63.89,93.17a58.64,58.64,0,0,1,98.56,28.11,12,12,0,1,1-23.37,5.44,34.65,34.65,0,0,0-58.22-16.58L46.11,144.89A34.62,34.62,0,0,0,70.57,204h0a34.41,34.41,0,0,0,24.49-10.14l5.11-5.12A12,12,0,0,1,117.18,188.74ZM226.83,45.17a58.65,58.65,0,0,0-82.93,0l-5.11,5.11a12,12,0,0,0,17,17l5.12-5.12a34.63,34.63,0,1,1,49,49L175.1,145.86A34.39,34.39,0,0,1,150.61,156h0a34.63,34.63,0,0,1-33.69-26.72,12,12,0,0,0-23.38,5.44A58.64,58.64,0,0,0,150.56,180h.05a58.28,58.28,0,0,0,41.47-17.17l34.75-34.75a58.62,58.62,0,0,0,0-82.91Z"/></svg>',
    "Lock": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M208,76H180V56A52,52,0,0,0,76,56V76H48A20,20,0,0,0,28,96V208a20,20,0,0,0,20,20H208a20,20,0,0,0,20-20V96A20,20,0,0,0,208,76ZM100,56a28,28,0,0,1,56,0V76H100ZM204,204H52V100H204Zm-60-52a16,16,0,1,1-16-16A16,16,0,0,1,144,152Z"/></svg>',
    "Trust": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M208,36H48A20,20,0,0,0,28,56v56c0,54.29,26.32,87.22,48.4,105.29,23.71,19.39,47.44,26,48.44,26.29a12.1,12.1,0,0,0,6.32,0c1-.28,24.73-6.9,48.44-26.29,22.08-18.07,48.4-51,48.4-105.29V56A20,20,0,0,0,208,36Zm-4,76c0,35.71-13.09,64.69-38.91,86.15A126.28,126.28,0,0,1,128,219.38a126.14,126.14,0,0,1-37.09-21.23C65.09,176.69,52,147.71,52,112V60H204ZM79.51,144.49a12,12,0,1,1,17-17L112,143l47.51-47.52a12,12,0,0,1,17,17l-56,56a12,12,0,0,1-17,0Z"/></svg>',
    "Warning": '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 256" fill="currentColor"><path d="M240.26,186.1,152.81,34.23h0a28.74,28.74,0,0,0-49.62,0L15.74,186.1a27.45,27.45,0,0,0,0,27.71A28.31,28.31,0,0,0,40.55,228h174.9a28.31,28.31,0,0,0,24.79-14.19A27.45,27.45,0,0,0,240.26,186.1Zm-20.8,15.7a4.46,4.46,0,0,1-4,2.2H40.55a4.46,4.46,0,0,1-4-2.2,3.56,3.56,0,0,1,0-3.73L124,46.2a4.77,4.77,0,0,1,8,0l87.44,151.87A3.56,3.56,0,0,1,219.46,201.8ZM116,136V104a12,12,0,0,1,24,0v32a12,12,0,0,1-24,0Zm28,40a16,16,0,1,1-16-16A16,16,0,0,1,144,176Z"/></svg>',
}


def icon_svg(m):
    name, style = m.group(1), m.group(2)
    return ICONS[name].replace("<svg ", f'<svg aria-hidden="true" style="display:block;{style}" ', 1)


def arrow_svg(m):
    # block arrow: head = last 40% of the length, like the Slides x-shape
    style = m.group(1)
    col = re.search(r"background:\s*([^;]+)", style).group(1)
    return (f'<svg aria-hidden="true" viewBox="0 0 100 50" preserveAspectRatio="none" style="display:block;{style};background:none">'
            f'<polygon points="0,15 60,15 60,0 100,25 60,50 60,35 0,35" fill="{col}"/></svg>')


deck = json.loads((DECK / "deck.json").read_text(encoding="utf-8"))
slides = []
for sid in deck["order"]:
    h = (DECK / "slides" / f"{sid}.html").read_text(encoding="utf-8")
    h = re.sub(r"<aside>[\s\S]*?</aside>", "", h)  # speaker notes stay private
    h = re.sub(r"/_blob/([0-9a-f]{32})", lambda m: "images/" + BLOBS[m.group(1)], h)
    h = re.sub(r'<x-icon name="(\w+)" style="([^"]*)"></x-icon>', icon_svg, h)
    h = re.sub(r'<x-shape kind="arrow-right" style="([^"]*)"></x-shape>', arrow_svg, h)
    if "<x-" in h or "/_blob/" in h:
        sys.exit(f"{sid}: unsupported element or unknown asset, update BLOBS/ICONS")
    slides.append(h.replace("<section ", '<section class="slide" ', 1).strip())

# copy the images actually used
(OUT / "images").mkdir(parents=True, exist_ok=True)
assets = DECK.parent / "assets"
for f in sorted(set(re.findall(r"images/([\w.-]+\.png)", "\n".join(slides)))):
    dst = OUT / "images" / f
    if (assets / f).exists():
        shutil.copy(assets / f, dst)
    elif not dst.exists():
        sys.exit(f"missing image {f}")

page = f"""<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="robots" content="noindex">
<title>{deck['title']} · ASC Balan</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Oswald:wght@400..700&family=Rubik:wght@400..700&display=swap">
<style>
*{{margin:0;padding:0;box-sizing:border-box}}
html,body{{height:100%;background:#120b17;overflow:hidden}}
body{{font-family:'Rubik',Arial,sans-serif;color:#22162B}}
#stage{{position:fixed;left:0;top:0;width:1920px;height:1080px;transform-origin:0 0}}
.slide{{position:absolute!important;left:0;top:0;width:1920px;height:1080px;overflow:hidden;display:none}}
.slide.current{{visibility:visible}}
.slide:not(.current){{display:none!important}}
.slide>*:not([style*="position:absolute"]):not([style*="position: absolute"]){{flex-shrink:0}}
h1{{font-size:96px;font-weight:600;line-height:1.1}}
h2{{font-size:64px;font-weight:600;line-height:1.15}}
h3{{font-size:44px;font-weight:600;line-height:1.2}}
p{{font-size:32px;line-height:1.4}}
a{{color:inherit}}
img{{display:block}}
table{{border-collapse:collapse}}
th,td{{padding:0.35em 0.6em;border-bottom:2px solid #D9CEDC;text-align:left}}
th{{font-weight:600}}
#ui{{position:fixed;left:0;right:0;bottom:0;display:flex;align-items:center;gap:12px;padding:8px 12px;
  font:14px/1 'Rubik',Arial,sans-serif;color:#CDBFD3;background:linear-gradient(transparent,rgba(18,11,23,.85));
  opacity:0;transition:opacity .3s}}
body:hover #ui,#ui:focus-within{{opacity:1}}
#ui button{{background:#22162B;color:#F8F4EE;border:1px solid #5C5163;border-radius:6px;padding:6px 10px;font:inherit;cursor:pointer}}
#bar{{flex:1;height:4px;background:#3a2b44;border-radius:2px;overflow:hidden}}
#bar span{{display:block;height:100%;background:#BF3DCE;width:0}}
@media (hover:none){{#ui{{opacity:1}}}}
</style>
</head>
<body>
<div id="stage">
{chr(10).join(slides)}
</div>
<div id="ui">
<button id="prev" aria-label="Slide précédente">←</button>
<button id="next" aria-label="Slide suivante">→</button>
<div id="bar"><span></span></div>
<span id="count"></span>
<button id="fs" aria-label="Plein écran">⛶</button>
<span id="hint" style="display:none">Plein écran : Partager › Sur l’écran d’accueil</span>
</div>
<script>
(function(){{
  var slides=[].slice.call(document.querySelectorAll('.slide')), i=0;
  var stage=document.getElementById('stage');
  function fit(){{
    // fixed stage scaled and centred in px: an off-screen 1920px box would widen the
    // layout viewport on phones and break the fit
    var W=innerWidth, H=innerHeight, s=Math.min(W/1920, H/1080);
    stage.style.transform='translate('+(W-1920*s)/2+'px,'+(H-1080*s)/2+'px) scale('+s+')';
  }}
  function show(n){{
    i=Math.max(0,Math.min(slides.length-1,n));
    slides.forEach(function(el,k){{el.classList.toggle('current',k===i)}});
    document.getElementById('count').textContent=(i+1)+' / '+slides.length;
    document.querySelector('#bar span').style.width=(100*(i+1)/slides.length)+'%';
    if(location.hash!=='#'+(i+1)) history.replaceState(null,'','#'+(i+1));
  }}
  addEventListener('resize',fit);
  addEventListener('orientationchange',function(){{setTimeout(fit,200)}});
  addEventListener('keydown',function(e){{
    if(['ArrowRight','PageDown',' ','Enter'].indexOf(e.key)>=0){{e.preventDefault();show(i+1)}}
    else if(['ArrowLeft','PageUp','Backspace'].indexOf(e.key)>=0){{e.preventDefault();show(i-1)}}
    else if(e.key==='Home') show(0);
    else if(e.key==='End') show(slides.length-1);
    else if(e.key==='f'||e.key==='F') toggleFs();
  }});
  // Fullscreen API with the WebKit prefix (older Safari, iPad); iPhone Safari has no
  // fullscreen for pages, so the button is hidden there and a hint is shown instead.
  var root=document.documentElement;
  var reqFs=root.requestFullscreen||root.webkitRequestFullscreen;
  var exitFs=document.exitFullscreen||document.webkitExitFullscreen;
  function fsElement(){{return document.fullscreenElement||document.webkitFullscreenElement}}
  function toggleFs(){{
    if(fsElement()) exitFs.call(document);
    else if(reqFs){{
      var p=reqFs.call(root);
      if(p&&p.then) p.then(function(){{
        if(screen.orientation&&screen.orientation.lock) screen.orientation.lock('landscape').catch(function(){{}});
      }}).catch(function(){{}});
    }}
  }}
  if(!reqFs){{
    var b=document.getElementById('fs'); b.style.display='none';
    var hint=document.getElementById('hint');
    var standalone=window.navigator.standalone||matchMedia('(display-mode: standalone)').matches;
    if(hint&&!standalone) hint.style.display='inline';
  }}
  document.getElementById('prev').onclick=function(e){{e.stopPropagation();show(i-1)}};
  document.getElementById('next').onclick=function(e){{e.stopPropagation();show(i+1)}};
  document.getElementById('fs').onclick=function(e){{e.stopPropagation();toggleFs()}};
  stage.addEventListener('click',function(e){{
    if(e.target.closest('a')) return;
    show(e.clientX < innerWidth/3 ? i-1 : i+1);
  }});
  var x0=null;
  addEventListener('touchstart',function(e){{x0=e.touches[0].clientX}},{{passive:true}});
  addEventListener('touchend',function(e){{
    if(x0===null) return; var dx=e.changedTouches[0].clientX-x0; x0=null;
    if(Math.abs(dx)>40) show(dx<0?i+1:i-1);
  }});
  addEventListener('hashchange',function(){{show((parseInt(location.hash.slice(1))||1)-1)}});
  fit(); show((parseInt(location.hash.slice(1))||1)-1);
}})();
</script>
</body>
</html>
"""
(OUT / "index.html").write_text(page, encoding="utf-8")
print(OUT / "index.html", len(slides), "slides", len(page) // 1024, "KB")
