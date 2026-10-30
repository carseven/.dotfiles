# Onboarding: Nuevo Atleta

Proceso para crear el perfil cuando no existe ATHLETE.md.

La entrevista cubre los campos **core** del perfil. Los campos avanzados (baselines de recuperación, nutrición, exportación, periodización, métricas de Garmin) se completan progresivamente conforme el coach interactúa con el atleta.

---

## 1. Detección

Resolver `<coach_dir>` según `SKILL.md` («Resultados — vault de Obsidian»): `~/notes/notes/coach/` por defecto; si la carpeta no existe, preguntar al atleta la ruta.

Buscar `<coach_dir>/ATHLETE.md`.

Si la carpeta existe pero el archivo no → iniciar onboarding.

---

## 2. Entrevista

Recoge información siguiendo las secciones de ATHLETE.md.
No hagas todas las preguntas de golpe — agrupa en bloques conversacionales. Espera respuesta de cada bloque antes de pasar al siguiente.

### Bloque 1: Conocerte

_Rellena: §1 Información Personal (datos, salud, disponibilidad)_

- Nombre, edad, peso/altura
- Ubicación y clima habitual
- Condiciones de salud actuales
- Lesiones pasadas relevantes
- Días y horarios disponibles para correr
- Otras actividades deportivas (gimnasio, escalada, alpinismo...) — días y horario
- Preferencia de día para tirada larga
- Prioridad vida-deporte

### Bloque 2: Tu running

_Rellena: §2 Información Deportiva (historial, zonas, equipo)_

- Historial deportivo (¿cuánto llevas corriendo? ¿de qué vienes? ¿has competido?)
- Volumen semanal típico (km/semana o horas/semana)
- Ritmos de referencia (¿ritmo cómodo? ¿algún test reciente?)
- Dispositivo/reloj (¿usas Garmin, Coros, otro?)
- ¿Tienes zonas de FC configuradas en el dispositivo?

### Bloque 3: Objetivos

_Rellena: §3 Objetivos (metas, carreras)_

- Objetivo principal (carrera concreta, marca, mejorar forma, retomar tras pausa...)
- Horizonte temporal (¿para cuándo?)
- ¿Tienes alguna carrera apuntada o en mente? (fecha, distancia, tipo)

### Bloque 4: Cómo trabajamos

_Rellena: §4 Preferencias (filosofía, estilo, feedback)_

- Filosofía (consistencia vs intensidad, volumen vs calidad)
- Estilo de coaching preferido (exigente, empático, técnico, flexible)
- Tipo de feedback preferido (datos objetivos, sensaciones, mixto)
- ¿Sueles rellenar RPE/Feel/Notas en Garmin después de cada actividad?

---

## 3. Campos que se completan progresivamente

Estos campos NO se preguntan en el onboarding. El coach los rellena conforme trabaja con el atleta:

| Campo | Cuándo se completa | Fuente |
|-------|-------------------|--------|
| Métricas fisiológicas (VO2max, LTHR, FC max) | Pull inicial de Garmin o primeras semanas | skill `garmin` |
| Modelo de zonas y zonas detalladas | Pull de Garmin o test | Dispositivo |
| Distribución de intensidad | Tras analizar primeras semanas | Decisión del coach |
| Herramientas de medición (RPE, potencia) | Conforme se usan | Observación |
| Baselines de recuperación (HRV, RHR, sueño) | 2-4 semanas de datos | skill `garmin` |
| Modelo de periodización | Al diseñar el primer plan | Decisión del coach |
| Nutrición (train-low, fueling, GI) | Cuando se aborde nutrición | Conversación |
| Reglas de exportación | Primera exportación | Conversación |
| Estado de forma (métricas Garmin) | Cada actualización de Momentum | skill `garmin` |
| Observaciones críticas | Conforme se detectan patrones | Análisis continuo |

---

## 4. Defaults inteligentes

Si el atleta no especifica, asume estos valores por defecto:

| Campo | Default | Nota |
|-------|---------|------|
| Zonas FC | Referencia Garmin si disponible | Si no, estimar con FC max teórica (220-edad) |
| Días de descanso | Lunes | Ajustar según preferencia |
| Tirada larga | Sábado o domingo | Preguntar preferencia |
| Sesiones calidad/semana | 2 | Max para principiante-intermedio |
| Estilo coaching | Equilibrado | Técnico + empático |
| Semana de descarga | Cada 3 semanas | Más frecuente si principiante |
| Distribución intensidad | 80/20 | Ajustar si principiante (85/15) |
| Post-actividad | No completa RPE/Notas | Sugerir que lo haga |

---

## 5. Crear el perfil

1. Usar la template: `references/athlete-template.md`
2. Rellenar con la información recopilada en la entrevista
3. Dejar secciones no cubiertas con los placeholders del template (NO inventar)
4. La sección **Momentum** se rellena con la fase inicial (normalmente "Base" o "Reacondicionamiento")
5. Guardar en `<coach_dir>/ATHLETE.md` (vault de Obsidian), con frontmatter `title` y `tags` (`coach/athlete`, `personal/deporte`)
6. Si tiene Garmin conectado: invocar la skill `garmin` para un pull inicial de métricas y completar §2 (fisiológicas, zonas, baselines)

---

## 6. Post-onboarding

1. Confirmar al usuario: mostrar resumen del perfil creado
2. `add_memory(content="Onboarding completado. Perfil creado con [resumen breve]")`
3. Preguntar: ¿quieres que te prepare un plan de entrenamiento?
