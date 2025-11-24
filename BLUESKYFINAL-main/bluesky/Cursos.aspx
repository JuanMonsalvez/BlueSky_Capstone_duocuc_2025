<%@ Page Title="CURSOS DISPONIBLES - BLUESKY FINANCIAL" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cursos.aspx.cs" Inherits="bluesky.Cursos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* ===========================
       Filtros
    =========================== */
        .crs2-filterbar {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin: 8px 0 20px;
        }

        .crs2-dd {
            position: relative;
        }

            .crs2-dd > button {
                min-width: 200px;
                height: 40px;
                padding: 0 12px;
                border: 0;
                border-radius: 8px;
                color: #fff;
                font-weight: 800;
                background: #1E66F5;
                box-shadow: 0 4px 12px rgba(30,102,245,.25);
                display: flex;
                align-items: center;
                justify-content: space-between;
                cursor: pointer;
            }

            .crs2-dd > ul {
                position: absolute;
                top: 44px;
                left: 0;
                min-width: 100%;
                background: #fff;
                border: 1px solid #E6E8F5;
                border-radius: 8px;
                padding: 6px;
                margin: 0;
                list-style: none;
                display: none;
                box-shadow: 0 10px 20px rgba(16,24,40,.12);
                z-index: 5;
            }

            .crs2-dd.open > ul {
                display: block;
            }

            .crs2-dd li > a {
                display: block;
                padding: 6px 8px;
                border-radius: 6px;
                text-decoration: none;
                color: #0b1220;
            }

                .crs2-dd li > a:hover {
                    background: #F3F6FF;
                }

        /* ===========================
        Grid + Cards súper compactas
    =========================== */
        .crs2-grid > [class^="col-"] {
            display: flex;
        }

        .crs2-card {
            background: #fff;
            border: 1px solid #EAEFF5;
            border-radius: 14px;
            overflow: hidden;
            box-shadow: 0 6px 16px rgba(16,24,40,.08);
            display: flex;
            flex-direction: column;
            width: 100%;
            transition: .16s;
        }

            .crs2-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 12px 24px rgba(16,24,40,.12);
                border-color: #DFE5FF;
            }

        .crs2-img img {
            width: 100%;
            height: 150px; /* SUPER BAJA */
            object-fit: cover;
        }

        .crs2-body {
            padding: 8px 12px 6px;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .crs2-kind {
            font-size: 0.9rem;
            padding-left: 8px;
            font-weight: 700;
            color: #1E66F5;
            position: relative;
        }

            .crs2-kind::before {
                content: "";
                position: absolute;
                left: 0;
                top: 3px;
                width: 3px;
                height: 12px;
                background: #1E66F5;
                border-radius: 2px;
            }

        /* ===========================
        Título compacto
    =========================== */
        .crs2-name {
            margin: 2px 0 4px;
            font-weight: 800;
            font-size: 1.2rem; /* Antes 1.55 → ahora súper compacto */
            color: #0f172a;
            line-height: 1.25;
            text-align: center;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: calc(1.2rem * 1.25 * 2);
            cursor: help;
        }

        /* ===========================
        Meta mucho más pequeña
    =========================== */
        .crs2-meta {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            gap: 3px;
            color: #475569;
            font-size: 0.8rem; /* antes 1.2rem */
        }

        .crs2-foot {
            padding: 8px 12px;
            border-top: 1px solid #EEF1F7;
            display: flex;
            justify-content: flex-end;
        }

        .crs2-more {
            font-weight: 700;
            font-size: 1rem; /* más pequeño */
            color: #2A3DF5;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }

        .col-xl-3, .col-lg-3, .col-md-6, .col-sm-12 {
            margin-bottom: 20px; /* más pequeño */
        }

        /* ===========================
        Responsive
    =========================== */
        @media (max-width:991px) {
            .crs2-img img {
                height: 140px;
            }
        }

        @media (max-width:767px) {
            .crs2-img img {
                height: 130px;
            }

            .crs2-name {
                font-size: 1.1rem;
            }
        }

        @media (max-width:575px) {
            .crs2-img img {
                height: 120px;
            }

            .crs2-name {
                font-size: 1rem;
            }
        }

        /* ===========================
        Tooltip (sin cambios)
    =========================== */
        .crs2-tooltip {
            position: absolute;
            background: #0f172a;
            color: #fff;
            padding: 8px 10px;
            border-radius: 8px;
            font-size: 14px;
            line-height: 1.35;
            max-width: 300px;
            pointer-events: none;
            opacity: 0;
            transform: translateY(-4px);
            transition: .15s;
            box-shadow: 0 10px 24px rgba(16,24,40,.18);
        }

            .crs2-tooltip.show {
                opacity: 1;
                transform: translateY(0);
            }

            .crs2-tooltip::after {
                content: "";
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
                bottom: -6px;
                border-width: 6px 6px 0 6px;
                border-style: solid;
                border-color: #0f172a transparent transparent transparent;
            }

            .crs2-tooltip.bottom::after {
                top: -6px;
                border-width: 0 6px 6px 6px;
                border-color: transparent transparent #0f172a transparent;
            }
    </style>

    <div class="container crs2-wrap">
        <!-- Título -->
        <h3 class="crs2-title">Filtro de búsqueda</h3>

        <!-- Filtros (dropdown visual) -->
        <div class="crs2-filterbar">
            <div class="crs2-dd">
                <button type="button">Nivel <i class='bx bx-chevron-down'></i></button>
                <ul>
                    <li><a href="#">Mostrar todos</a></li>
                    <li><a href="#">Básico</a></li>
                    <li><a href="#">Intermedio</a></li>
                    <li><a href="#">Avanzado</a></li>
                </ul>
            </div>
        </div>

        <!-- Grid de 4x por fila en lg+ (col-lg-3) -->
        <div class="row crs2-grid g-4 align-items-stretch">

            <asp:Repeater ID="rptCursos" runat="server">
                <ItemTemplate>
                    <div class="col-xl-3 col-lg-3 col-md-6 col-sm-12">
                        <article class="crs2-card h-100">
                            <figure class="crs2-img">
                                <img src='<%# 
    string.IsNullOrEmpty(Eval("imagen_url") as string)
    ? GetImagenCurso(Eval("nombre") as string)
    : Eval("imagen_url") 
%>'
                                    alt='<%# Eval("nombre") %>' />
                            </figure>
                            <div class="crs2-body">
                                <span class="crs2-kind">Curso</span>
                                <h5 class="crs2-name"><%# Eval("nombre") %></h5>
                                <div class="crs2-meta">
                                    <span>
                                        <i class="fa fa-calendar"></i>
                                        <%# Eval("fecha_inicio", "{0:dd-MM-yyyy}") %>
                                    </span>
                                    <span>
                                        <i class="fa fa-clock-o"></i>
                                        <%# Eval("duracion_horas") %> horas
                                    </span>
                                    <span>
                                        <i class="fa fa-dot-circle-o"></i>
                                        Modalidad: <%# Eval("modalidad") %>
                                    </span>
                                </div>
                            </div>
                            <div class="crs2-foot">
                                <a href='<%# GetUrlDetalleCurso(Eval("nombre") as string) %>'
                                    class="crs2-more">Ver más <i class="bx bx-chevron-right"></i>
                                </a>
                            </div>
                        </article>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>

    <!-- JS mínimo para abrir/cerrar los dropdowns visuales -->
    <script>
        (function () {
            var dds = document.querySelectorAll('.crs2-dd');
            dds.forEach(function (dd) {
                var btn = dd.querySelector('button');
                btn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    dds.forEach(x => { if (x !== dd) x.classList.remove('open'); });
                    dd.classList.toggle('open');
                });
            });
            document.addEventListener('click', function () { dds.forEach(x => x.classList.remove('open')); });
        })();
    </script>

    <script>
        (function () {
            // Crear el contenedor global del tooltip
            var tooltip = document.createElement('div');
            tooltip.className = 'crs2-tooltip';
            tooltip.id = 'crs2-tooltip';
            tooltip.setAttribute('role', 'tooltip');
            document.body.appendChild(tooltip);

            // Seleccionar todos los títulos de curso
            var items = document.querySelectorAll('.crs2-name');

            // Handlers reutilizables
            function showTip(evt) {
                var el = evt.currentTarget || evt; // el .crs2-name
                var text = (el.getAttribute('data-tip') || el.textContent || '').trim();
                if (!text) return;

                tooltip.textContent = text;
                tooltip.classList.add('show');
            }

            function hideTip() {
                tooltip.classList.remove('show', 'bottom');
            }

            function moveTip(evt) {
                if (!tooltip.classList.contains('show')) return;

                var scrollX = window.pageXOffset;
                var scrollY = window.pageYOffset;
                var vw = document.documentElement.clientWidth;
                var padding = 12;      // separación puntero↔tooltip
                var margin = 8;        // margen desde los bordes
                var tw = tooltip.offsetWidth;
                var th = tooltip.offsetHeight;

                // Centrar horizontal respecto al puntero
                var x = evt.clientX + scrollX - tw / 2;

                // Posición arriba (por defecto)
                var yTop = evt.clientY + scrollY - th - padding;

                // Posición abajo (si no hay espacio arriba)
                var yBottom = evt.clientY + scrollY + padding;

                // Limitar dentro del viewport horizontalmente
                if (x < scrollX + margin) x = scrollX + margin;
                if (x + tw > scrollX + vw - margin) x = scrollX + vw - margin - tw;

                // ¿Hay espacio arriba? si no, colocamos abajo y marcamos "bottom"
                if (evt.clientY - th - padding < 0) {
                    tooltip.classList.add('bottom');
                    tooltip.style.left = x + 'px';
                    tooltip.style.top = yBottom + 'px';
                } else {
                    tooltip.classList.remove('bottom');
                    tooltip.style.left = x + 'px';
                    tooltip.style.top = yTop + 'px';
                }
            }

            // Conectar eventos a cada .crs2-name
            items.forEach(function (el) {
                var full = (el.getAttribute('data-tip') || el.textContent || '').trim();
                el.setAttribute('data-tip', full);

                el.setAttribute('tabindex', '0');
                el.setAttribute('aria-describedby', 'crs2-tooltip');

                el.addEventListener('mouseenter', showTip);
                el.addEventListener('mouseleave', hideTip);
                el.addEventListener('mousemove', moveTip);

                el.addEventListener('focus', showTip);
                el.addEventListener('blur', hideTip);

                el.addEventListener('touchstart', function (ev) {
                    if (ev.touches && ev.touches[0]) {
                        showTip({ currentTarget: el });
                        moveTip({ clientX: ev.touches[0].clientX, clientY: ev.touches[0].clientY });
                        setTimeout(hideTip, 1500);
                    }
                }, { passive: true });
            });
        })();
    </script>

    <script>
        // === Filtro por NIVEL (Básico / Intermedio / Avanzado / Mostrar todos) ===
        (function () {
            function normalize(s) {
                return (s || "")
                    .normalize("NFD").replace(/[\u0300-\u036f]/g, "")
                    .toLowerCase();
            }

            function nivelDesdeTitulo(titulo) {
                const t = normalize(titulo);
                if (/\bintermedi\w*\b/.test(t)) return "Intermedio";
                if (/\bavanzad\w*\b/.test(t)) return "Avanzado";
                if (/\bbasic\w*\b/.test(t)) return "Básico";
                return "Básico";
            }

            var cards = document.querySelectorAll('.crs2-card');
            cards.forEach(function (card) {
                var titulo = card.querySelector('.crs2-name')?.textContent.trim() || "";
                var nivel = nivelDesdeTitulo(titulo);
                card.dataset.nivel = nivel;
            });

            var nivelDd = Array.from(document.querySelectorAll('.crs2-filterbar .crs2-dd'))
                .find(function (dd) {
                    var btn = dd.querySelector('button');
                    return btn && normalize(btn.textContent).startsWith('nivel');
                });

            if (!nivelDd) return;

            var nivelBtn = nivelDd.querySelector('button');
            var nivelLinks = nivelDd.querySelectorAll('ul a');

            function setNivelLabel(texto) {
                var icon = nivelBtn.querySelector('.bx');
                var label = 'Nivel: ' + texto + ' ';
                nivelBtn.innerHTML = icon ? (label + icon.outerHTML) : label;
            }

            function mostrarTodos() {
                document.querySelectorAll('.crs2-grid [class*="col-"]').forEach(function (col) {
                    col.style.display = '';
                });
                setNivelLabel('Todos');
            }

            nivelLinks.forEach(function (a) {
                a.addEventListener('click', function (e) {
                    e.preventDefault();
                    var seleccionado = this.textContent.trim();
                    var selNorm = normalize(seleccionado);

                    nivelDd.classList.remove('open');

                    if (selNorm.includes('todos')) {
                        mostrarTodos();
                        return;
                    }

                    setNivelLabel(seleccionado);

                    cards.forEach(function (card) {
                        var col = card.closest('[class*="col-"]') || card.parentElement;
                        if (!col) return;
                        col.style.display = (card.dataset.nivel === seleccionado) ? '' : 'none';
                    });
                });
            });

            var lastClick = 0;
            nivelBtn.addEventListener('click', function () {
                var now = Date.now();
                if (now - lastClick < 350) {
                    mostrarTodos();
                }
                lastClick = now;
            });
        })();
    </script>

</asp:Content>
