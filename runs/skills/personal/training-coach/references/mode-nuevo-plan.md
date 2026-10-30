# Modo «Nuevo plan» — crear un plan desde cero

Objetivo: crear `<coach_dir>/plans/<objetivo>/informe.md` completo, con el objetivo, el perfil del atleta, la periodización, la estructura semanal y las rutinas.

No guardes nada hasta que el atleta apruebe el borrador (paso 5).

---

## 1. Preparación

1. Resolver `<coach_dir>` según `SKILL.md` («Resultados — vault de Obsidian»).
2. Perfil del atleta:
   - Si ya hay planes, copia el apartado «Perfil del atleta» del plan más reciente como punto de partida. Es una copia, sin enlace. Actualízala con el estado actual y confírmala con el atleta.
   - Si no hay ningún plan, haz la entrevista de `references/onboarding.md` y vuelve aquí.
3. No cites ni enlaces otros planes. Cada plan es independiente.

## 2. Objetivo

Pregunta lo que falte:

- Objetivo: carrera, ascensión, nivel de escalada o mejora de forma.
- Fecha, tipo, distancia, desnivel y prioridad (A, B o C).
- Restricciones: disponibilidad, lesiones, viajes.

Si el objetivo es una carrera, busca su reglamento y su track si hay herramientas web. Marca como «sin confirmar» lo que no puedas verificar. No inventes datos.

## 3. Estado actual con datos reales

1. Sincroniza Zepp (con consentimiento) y lee Strava, como en `SKILL.md` («Zepp Life — caché local» y «Strava — Segunda fuente de entrenos»). Cubre los últimos 28-60 días.
2. Calcula: horas, km, D+ y km-esfuerzo por semana, sesiones de fuerza y de escalada, y FC de reposo.
3. Usa esos datos en los apartados 3.3 y 3.8 del perfil.
4. Si no hay datos, pregunta al atleta. No los estimes.

## 4. Diseño

1. **Semanas disponibles:** fecha del objetivo menos hoy. Elige las fases con la Parte 3 del manual (`manual-entrenamiento-escalada-montana.md`) y la §1 de `methodology.md`. Si la ventana es más corta que las fases del manual, comprímelas y justifícalo.
2. **Reglas del manual:** progresión de volumen o D+ ≤10% por semana, base en Z1-Z2, fuerza máxima antes de resistencia muscular, sesiones neuromusculares con el sistema nervioso fresco y 1 día de descanso por semana.
3. **Estructura semanal:** reparte las sesiones según la disponibilidad del perfil (3.2). Separa las sesiones duras para evitar fatiga compartida.
4. **Rutinas:** carga la reference de cada disciplina (`strength.md`, `climbing.md`, `alpinism.md`). Para cada rutina escribe una tabla de ejercicio, series, repeticiones, descanso y nota, y su progresión por fase. Respeta las reglas de dolor del perfil (3.1).
5. **Salidas largas:** progresión por semana de duración y D+, con un simulacro cerca del pico.
6. **Nutrición:** si hay carrera, define el fueling con el perfil (3.5).
7. **Seguimiento:** prepara la tabla semanal de km, D+ y km-esfuerzo con las estimaciones del plan. El modo Sync la rellena con datos reales.

## 5. Borrador y aprobación

Antes de guardar, muestra al atleta un borrador breve:

- Objetivo y fecha.
- Fases con fechas.
- Estructura semanal.
- Lista de rutinas.
- Supuestos y datos por confirmar.

Espera su aprobación o sus cambios. Aplica los cambios y vuelve a mostrar lo que cambió.

## 6. Guardar

Crea `<coach_dir>/plans/<objetivo>/informe.md` con frontmatter `title` y `tags` (`coach/plan`, `personal/deporte`). Usa esta estructura:

| Sección | Contenido |
| ------- | --------- |
| 1 | El objetivo o la carrera |
| 2 | Perfil del recorrido o del objetivo |
| 3 | Perfil del atleta: copia completa con la estructura de `references/athlete-template.md` |
| 4 | Periodización: fases y calendario de semanas con su estado |
| 5 | Estructura semanal |
| 6 | Rutinas: cada una empieza con su bloque «Contexto del atleta» |
| 7 | Pendiente y próximos pasos |
| 8 | Km y desnivel acumulado por semana |

Las revisiones posteriores del modo Sync se añaden al final con el número siguiente. No enlaces a otros planes.

## 7. Cierre

1. Ofrece exportar un calendario `.ics` (skill `ical`). Guarda el `.ics` en la misma carpeta del plan.
2. Termina con el siguiente paso concreto: la primera sesión y cuándo hacer el primer Sync.
