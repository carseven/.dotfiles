# Onboarding: Nuevo Atleta

Proceso para recoger el perfil del atleta cuando no hay ningún plan en `<coach_dir>/plans/`. Lo usa el modo Nuevo plan (`references/mode-nuevo-plan.md`). El perfil se guarda dentro del informe del plan, no en un archivo aparte.

La entrevista cubre los campos **core** del perfil. Los campos avanzados (baselines de recuperación, nutrición, exportación, periodización, métricas de Garmin) se completan progresivamente conforme el coach interactúa con el atleta.

---

## 1. Detección

Resolver `<coach_dir>` según `SKILL.md` («Resultados — vault de Obsidian»): `~/notes/notes/coach/` por defecto; si la carpeta no existe, preguntar al atleta la ruta.

Buscar `<coach_dir>/plans/*/informe.md`.

Si la carpeta existe pero ningún informe tiene el apartado «Perfil del atleta» → iniciar onboarding.

---

## 2. Entrevista

Recoge información siguiendo los apartados de `references/athlete-template.md`.
No hagas todas las preguntas de golpe — agrupa en bloques conversacionales. Espera respuesta de cada bloque antes de pasar al siguiente.

### Bloque 1: Conocerte

_Rellena: 3.1 Salud y 3.2 Disponibilidad y estructura de entrenamiento_

- Nombre, edad, peso/altura
- Ubicación y clima habitual
- Condiciones de salud actuales
- Lesiones pasadas relevantes
- Días y horarios disponibles para correr
- Otras actividades deportivas (gimnasio, escalada, alpinismo...) — días y horario
- Preferencia de día para tirada larga
- Prioridad vida-deporte

### Bloque 2: Tu entrenamiento

_Rellena: 3.3 Capacidad y métricas, 3.4 Zonas de FC y 3.6 Fuerza, escalada y montaña_

- Historial deportivo (¿cuánto llevas corriendo? ¿de qué vienes? ¿has competido?)
- Volumen semanal típico (km/semana o horas/semana)
- Ritmos de referencia (¿ritmo cómodo? ¿algún test reciente?)
- Montaña y alpinismo: salidas largas habituales, desnivel, mochila, altitud y material (botas, bastones)
- Escalada: tipo (boulder, deportiva, vía larga), nivel máximo, frecuencia y lesiones de dedos
- Fuerza: días por semana, cargas de referencia y número de dominadas estrictas
- Dispositivo/reloj (¿usas Garmin, Coros, otro?)
- ¿Tienes zonas de FC configuradas en el dispositivo?

### Bloque 3: Objetivos

_Rellena: 3.7 Calendario de carreras y la sección 1 del informe (objetivo)_

- Objetivo principal (carrera concreta, marca, mejorar forma, retomar tras pausa...)
- Horizonte temporal (¿para cuándo?)
- ¿Tienes alguna carrera apuntada o en mente? (fecha, distancia, tipo)

### Bloque 4: Cómo trabajamos

_Rellena: 3.2 (preferencias de coaching)_

- Filosofía (consistencia vs intensidad, volumen vs calidad)
- Estilo de coaching preferido (exigente, empático, técnico, flexible)
- Tipo de feedback preferido (datos objetivos, sensaciones, mixto)
- ¿Sueles rellenar RPE/Feel/Notas en Garmin después de cada actividad?

---

## 3. Campos que se completan progresivamente

Estos campos NO se preguntan en el onboarding. El coach los rellena conforme trabaja con el atleta:

| Campo | Cuándo se completa | Fuente |
|-------|-------------------|--------|
| Métricas fisiológicas (VO2max, LTHR, FC max) y FC de reposo | Pull inicial de Garmin o primeras semanas | skill `garmin` |
| FC en el umbral aeróbico (AeT) y test del 10% | Cuando se haga el test de campo del manual | Test de campo |
| Modelo de zonas y zonas detalladas | Pull de Garmin o test | Dispositivo |
| Baselines de recuperación (HRV, sueño) | 2-4 semanas de datos | skill `garmin` |
| Nutrición (tolerancia, fueling, GI) | Cuando se aborde nutrición | Conversación |
| Estado actual | Cada actualización del plan | skill `garmin` y conversación |
| Observaciones | Conforme se detectan patrones | Análisis continuo |

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

## 5. Preparar el perfil

No guardes aún el informe: el modo Nuevo plan lo guarda cuando el atleta aprueba el borrador (paso 6 de `mode-nuevo-plan.md`). Prepara el perfil en borrador:

1. Usar la estructura de `references/athlete-template.md` para el apartado 3 «Perfil del atleta» y rellenarla con la entrevista
2. Dejar sin rellenar los apartados no cubiertos y listarlos en 3.10 «Datos por completar» (NO inventar)
3. El apartado 3.8 «Estado actual» se rellena con la fase inicial (normalmente "Base" o "Reacondicionamiento")
4. Si tiene Garmin conectado: invocar la skill `garmin` para un pull inicial de métricas y completar 3.3 y 3.4
5. Más adelante, al diseñar el plan, cada rutina lleva un bloque «Contexto del atleta» con los datos del perfil que le afectan

---

## 6. Post-onboarding

1. Confirmar al usuario: mostrar resumen del perfil
2. `add_memory(content="Onboarding completado. Perfil creado con [resumen breve]")`
3. Continuar con el paso 2 («Objetivo») de `references/mode-nuevo-plan.md`
