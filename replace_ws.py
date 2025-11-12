from pathlib import Path
path = Path(r'g:\My Drive\Games\Quack Noir\QuackNoirTest-New.html')
text = path.read_text(encoding='utf-8')
old = """                                if (!game.enemySprites.wunderswan || !game.enemySprites.wunderswan.image) {                                                                                           const preKick = new Image();
                                    preKick.onload = function(){
                                        console.info('[WunderswanSprite][pre-kick] loaded', { nw: preKick.naturalWidth, nh: preKick.naturalHeight });                                                     // If loaded but has zero size, attempt a re-request with decoded/encoded variants
                                        if ((preKick.naturalWidth || 0) === 0 || (preKick.naturalHeight || 0) === 0) {
                                            try {
                                                const alt = tryAlternateWunderswanUrl(preKick.src);                                                                                                               if (alt && alt !== preKick.src) { console.info('[WunderswanSprite][pre-kick] retrying alt URL', alt); preKick.src = alt; }
                                            } catch(_){ }
                                        }
                                    };
                                    preKick.onerror = function(ev){ console.warn('[WunderswanSprite][pre-kick] failed', ev); };
                                    try { preKick.src = new URL('assets/wunderswan.png', document.baseURI).href; console.info('[WunderswanSprite][pre-kick] requesting', preKick.src); } catch(e){ preKick.src = 'assets/wunderswan.png'; }                                            // keep reference
                                    game._wunderswan_preKick = preKick;
                                } else {
                                    try { const ws = game.enemySprites.wunderswan; if (ws && ws.image && (!ws.image.src || !ws.image.src.includes('wunderswan.png'))) { ws.image.src = 'assets/wunderswan.png'; console.info('[WunderswanSprite][pre-kick] set existing image.src'); } } catch(_){ }                                                                 }
"""
new = """                                if (!game.enemySprites.wunderswan || !game.enemySprites.wunderswan.image) {
                                    const preKick = new Image();
                                    preKick.onload = function(){
                                        console.info('[WunderswanSprite][pre-kick] loaded', { nw: preKick.naturalWidth, nh: preKick.naturalHeight });
                                        try {
                                            const ws = game.enemySprites && game.enemySprites.wunderswan;
                                            if (ws) {
                                                ws.image = preKick;
                                                ws.loaded = true;
                                                if (typeof ws._applySheetFrames === 'function') {
                                                    ws._applySheetFrames(preKick);
                                                }
                                            }
                                        } catch(_){ }
                                        if ((preKick.naturalWidth || 0) === 0 || (preKick.naturalHeight || 0) === 0) {
                                            try {
                                                const alt = tryAlternateWunderswanUrl(preKick.src);
                                                if (alt && alt !== preKick.src) {
                                                    console.info('[WunderswanSprite][pre-kick] retrying alt URL', alt);
                                                    preKick.src = alt;
                                                }
                                            } catch(_){ }
                                        }
                                    };
                                    preKick.onerror = function(ev){ console.warn('[WunderswanSprite][pre-kick] failed', ev); };
                                    const sheetSrc = 'assets/wunderswan-sheet-1-30.png';
                                    try { preKick.src = new URL(sheetSrc, document.baseURI).href; console.info('[WunderswanSprite][pre-kick] requesting', preKick.src); } catch(e){ preKick.src = sheetSrc; }
                                    game._wunderswan_preKick = preKick;
                                } else {
                                    try {
                                        const ws = game.enemySprites.wunderswan;
                                        if (ws && ws.image && (!ws.image.src || !ws.image.src.includes('wunderswan-sheet-1-30.png'))) {
                                            ws.image.src = 'assets/wunderswan-sheet-1-30.png';
                                            console.info('[WunderswanSprite][pre-kick] set existing image.src');
                                        }
                                    } catch(_){ }
                                }
"""
if old not in text:
    raise SystemExit('old block not found')
text = text.replace(old, new, 1)
path.write_text(text, encoding='utf-8')
