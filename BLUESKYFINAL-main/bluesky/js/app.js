
// ---------- INIT (AOS + VanillaTilt) ----------
window.addEventListener('DOMContentLoaded', function () {
    // AOS
    try {
        if (window.AOS && typeof window.AOS.init === 'function') {
            window.AOS.init({
                duration: 800,
                once: true,
                offset: 80,
                easing: 'ease-out'
            });
        }
    } catch (e) { }

    // VanillaTilt
    try {
        if (window.VanillaTilt && typeof window.VanillaTilt.init === 'function') {
            window.VanillaTilt.init(document.querySelectorAll('[data-tilt]'), {
                max: 10,
                speed: 400,
                scale: 1.05,
                glare: false
            });
        }
    } catch (e) { }
});

// ---------- MODALES .modal-pro ----------
(function (factory) {
    if (typeof window.jQuery !== 'undefined') {
        factory(window.jQuery);
    } else {
        window.addEventListener('DOMContentLoaded', function () {
            if (typeof window.jQuery !== 'undefined') factory(window.jQuery);
        });
    }
})(function ($) {
    function shakeModal($modal) {
        if (!$modal || !$modal.length) return;
        $modal.addClass('shake');
        setTimeout(function () { $modal.removeClass('shake'); }, 500);
    }

    // 1) Foco accesible al abrir
    $(document).on('shown.bs.modal', '.modal-pro', function () {
        var $firstPrimary = $(this).find('.btn-primary:visible').first();
        if ($firstPrimary.length) {
            try { $firstPrimary.focus(); } catch (e) { }
        }
    });

    // 2) Click en backdrop con data-backdrop="static" => shake
    $(document).on('click', '.modal-pro', function (e) {
        var $modal = $(this);
        var clickedBackdrop = $(e.target).is('.modal');
        var isStatic = $modal.data('backdrop') === 'static';
        if (clickedBackdrop && isStatic) {
            shakeModal($modal);
        }
    });

    // 3) ESC con data-keyboard="false" => shake
    $(document).on('keydown', function (e) {
        if (e.key !== 'Escape') return;
        var $openModal = $('.modal-pro.in, .modal-pro.show').last();
        if (!$openModal.length) return;
        var keyboardEnabled = $openModal.data('keyboard');
        if (keyboardEnabled === false) {
            e.preventDefault();
            shakeModal($openModal);
        }
    });
});

// ==============================
// OFF-CANVAS ADMIN (IZQUIERDA)
// ==============================
(function () {
    var btn = document.querySelector('.admin-toggle-link');
    var panel = document.getElementById('adminSidePanel');
    var backdrop = document.getElementById('adminSideBackdrop');
    if (!btn || !panel || !backdrop) return;

    var focusableSel = 'a, button, input, textarea, select, [tabindex]:not([tabindex="-1"])';
    var onKeydown;

    function openPanel() {
        panel.classList.add('is-open');
        backdrop.classList.add('is-open');
        document.body.classList.add('admin-panel-open');

        btn.setAttribute('aria-expanded', 'true');
        panel.setAttribute('aria-hidden', 'false');
        backdrop.hidden = false;

        setTimeout(function () {
            var first = panel.querySelector(focusableSel);
            if (first) first.focus();
        }, 0);

        onKeydown = function (e) {
            if (e.key === 'Escape') { e.preventDefault(); closePanel(); }
            if (e.key === 'Tab') {
                var nodes = panel.querySelectorAll(focusableSel);
                if (!nodes.length) return;
                var first = nodes[0], last = nodes[nodes.length - 1];
                if (e.shiftKey && document.activeElement === first) { last.focus(); e.preventDefault(); }
                else if (!e.shiftKey && document.activeElement === last) { first.focus(); e.preventDefault(); }
            }
        };
        document.addEventListener('keydown', onKeydown);
    }

    function closePanel() {
        panel.classList.remove('is-open');
        backdrop.classList.remove('is-open');
        document.body.classList.remove('admin-panel-open');

        btn.setAttribute('aria-expanded', 'false');
        panel.setAttribute('aria-hidden', 'true');
        backdrop.hidden = true;

        btn.focus();
        document.removeEventListener('keydown', onKeydown);
    }

    btn.addEventListener('click', function (e) { e.preventDefault(); openPanel(); });

    var btnClose = panel.querySelector('.admin-panel-close');
    if (btnClose) btnClose.addEventListener('click', function (e) { e.preventDefault(); closePanel(); });

    backdrop.addEventListener('click', closePanel);
    panel.addEventListener('click', function (e) { e.stopPropagation(); });
})();

// ==============================
// Contact Validation UX (Web Forms)
// ==============================
(function () {
    function paintContactValidation() {
        try {
            if (typeof Page_Validators === "undefined") return;

            ["contactName", "contactEmail", "txtMotivo"].forEach(function (id) {
                var el = document.getElementById(id);
                if (!el) return;
                el.classList.remove("is-invalid", "is-valid");
            });

            for (var i = 0; i < Page_Validators.length; i++) {
                var v = Page_Validators[i];
                if (!v || v.validationGroup !== "Contact") continue;

                var ctl = document.getElementById(v.controltovalidate);
                if (!ctl) continue;

                if (v.isvalid === false) {
                    ctl.classList.add("is-invalid");
                    ctl.classList.remove("is-valid");
                } else {
                    var allOk = true;
                    for (var j = 0; j < Page_Validators.length; j++) {
                        var w = Page_Validators[j];
                        if (
                            w &&
                            w.controltovalidate === v.controltovalidate &&
                            w.validationGroup === "Contact" &&
                            w.isvalid === false
                        ) {
                            allOk = false;
                            break;
                        }
                    }
                    if (allOk && (ctl.value || "").trim() !== "") {
                        ctl.classList.remove("is-invalid");
                        ctl.classList.add("is-valid");
                    }
                }
            }
        } catch (e) { }
    }

    window.validateAndPaintContact = function () {
        if (typeof Page_ClientValidate === "function") {
            Page_ClientValidate("Contact");
        }
        paintContactValidation();
    };

    document.addEventListener("DOMContentLoaded", function () {
        paintContactValidation();

        ["contactName", "contactEmail", "txtMotivo"].forEach(function (id) {
            var el = document.getElementById(id);
            if (!el) return;
            ["input", "blur", "change"].forEach(function (evt) {
                el.addEventListener(evt, function () {
                    if (typeof Page_ClientValidate === "function") {
                        Page_ClientValidate("Contact");
                    }
                    paintContactValidation();
                });
            });
        });

        var btn = document.getElementById("btnContact");
        if (btn) {
            btn.addEventListener("click", function () {
                validateAndPaintContact();
            });
        }
    });
})();

// =============================================
// Contact Image (hover zoom + tilt minimal)
// =============================================
(function () {
    document.addEventListener('DOMContentLoaded', function () {
        var frame = document.getElementById('blueskyFrame');
        if (!frame) return;

        // Fallback tilt (si no hay VanillaTilt)
        var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var hasVanilla = !!(window.VanillaTilt && typeof window.VanillaTilt.init === 'function');

        if (!reduceMotion && !hasVanilla) {
            var MAX = 10, SCALE = 1.05;
            var rect = null, raf = null;

            function onMove(e) {
                if (!rect) rect = frame.getBoundingClientRect();
                var cx = rect.left + rect.width / 2;
                var cy = rect.top + rect.height / 2;
                var x = (e.clientX - cx) / (rect.width / 2);
                var y = (e.clientY - cy) / (rect.height / 2);
                var rx = (MAX * y);
                var ry = (-MAX * x);

                cancelAnimationFrame(raf);
                raf = requestAnimationFrame(function () {
                    frame.style.transform =
                        'perspective(900px) rotateX(' + rx + 'deg) rotateY(' + ry + 'deg) scale(' + SCALE + ')';
                });
            }
            function reset() {
                cancelAnimationFrame(raf);
                frame.style.transform = '';
                rect = null;
            }

            frame.addEventListener('mouseenter', function () { rect = frame.getBoundingClientRect(); });
            frame.addEventListener('mousemove', onMove);
            frame.addEventListener('mouseleave', reset);
            frame.addEventListener('blur', reset);
        }
        // Si VanillaTilt está cargado, ya quedó inicializado arriba.
    });
})();
// =============================================
// FEATURE: Progreso → Cards (hover/focus en dots)
// - Resalta y "mueve" la card vinculada
// - Soporta mouse, teclado y click con scroll suave
// =============================================
(function () {
    document.addEventListener('DOMContentLoaded', function () {
        var line = document.querySelector('.progress-line');
        if (!line) return;

        var dots = Array.prototype.slice.call(line.querySelectorAll('.dot'));
        var cardIds = ['cardPaso1', 'cardPaso2', 'cardPaso3'];

        function clearAll() {
            // Dots
            dots.forEach(function (d) { d.classList.remove('is-active'); });

            // Cards
            cardIds.forEach(function (id) {
                var c = document.getElementById(id);
                if (!c) return;
                c.classList.remove('card-highlight', 'card-wiggle-once');
            });
        }

        function highlightFor(dot) {
            var targetId = dot.getAttribute('data-target');
            var card = document.getElementById(targetId);
            if (!card) return;

            clearAll();

            // Activa dot + card
            dot.classList.add('is-active');
            card.classList.add('card-highlight', 'card-wiggle-once');

            // Quita solo el wiggle al terminar (deja el highlight mientras esté sobre el dot)
            var onEnd = function () {
                card.classList.remove('card-wiggle-once');
                card.removeEventListener('animationend', onEnd);
            };
            card.addEventListener('animationend', onEnd);
        }

        dots.forEach(function (dot) {
            // Mouse
            dot.addEventListener('pointerenter', function () { highlightFor(dot); });
            dot.addEventListener('pointerleave', function () {
                // Limpia solo si este dot seguía activo
                if (dot.classList.contains('is-active')) clearAll();
            });

            // Teclado (accesible)
            dot.addEventListener('focus', function () { highlightFor(dot); });
            dot.addEventListener('blur', function () {
                if (dot.classList.contains('is-active')) clearAll();
            });

            // Click: resalta y hace scroll suave a la card
            dot.addEventListener('click', function (e) {
                e.preventDefault();
                var targetId = dot.getAttribute('data-target');
                var card = document.getElementById(targetId);
                if (card && typeof card.scrollIntoView === 'function') {
                    card.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
            });
        });
    });
})();


