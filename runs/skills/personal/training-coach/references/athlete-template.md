# Perfil del atleta — plantilla

Estructura del apartado «Perfil del atleta» de un informe de plan (`<coach_dir>/plans/<objetivo>/informe.md`). Copia desde «## 3. Perfil del atleta» y rellénala con datos reales. La numeración 3.x supone que el perfil es la sección 3 del informe. Ajusta los números si cambia.

Reglas:

- No inventes datos. Deja sin rellenar lo que no sepas y lístalo en 3.10.
- Anota la fuente y la fecha entre paréntesis en cada métrica.
- No guardes datos que cambian en horas o en pocos días.
- Cada plan lleva su propia copia completa del perfil, como snapshot del estado del atleta. No enlaces a otros planes.
- Cada rutina del plan repite solo lo que le afecta, en un bloque «Contexto del atleta» (ver el final de este archivo).

---

## 3. Perfil del atleta

### 3.1 Salud

_Condiciones activas que afectan al entrenamiento y lesiones pasadas relevantes para prevención._

- **Condiciones actuales:**
- **Historial de lesiones:**
- **Zonas críticas del objetivo:** tramos o movimientos que cargan la zona lesionada

### 3.2 Disponibilidad y estructura de entrenamiento

- **Restricciones fijas:** días y horas no disponibles (trabajo, compromisos), acceso a desnivel
- **Estructura actual:** días de fuerza, escalada, cinta o stepper y salidas de montaña
- **Preferencias:** día de la tirada larga, horario, prioridad vida-deporte
- **Preferencias de coaching:** estilo (exigente, empático, técnico, flexible), nivel de detalle del feedback, datos objetivos frente a sensaciones

### 3.3 Capacidad y métricas

_Valores medidos o estimados. Fuente y fecha entre paréntesis._

- **Edad, peso y altura:**
- **Historial deportivo:** años, background, nivel
- **Ritmo de referencia (llano cómodo):**
- **Ritmo en montaña con mochila:**
- **VO2max:**
- **Umbral de lactato (LT):** bpm | ritmo
- **Umbral aeróbico (AeT):** bpm
- **Test del 10%:** diferencia entre la FC en el LT y en el AeT. Si supera el 10%, hay déficit aeróbico (ADS). Ver el manual de entrenamiento de escalada y montaña.
- **FC máxima:** medida o estimada
- **FC en reposo (baseline):**
- **HRV (baseline):** RMSSD y variación típica
- **Sueño habitual:**
- **Pruebas de rendimiento:** fecha, protocolo y resultado

### 3.4 Zonas de FC

_Referencias de intensidad. Indica el origen: FC máxima, LTHR o reserva cardíaca (Karvonen)._

- **Modelo:** (origen y fecha)
- **Z1:** (recuperación activa)
- **Z2:** (base aeróbica)
- **Z3:** (tempo)
- **Z4:** (umbral)
- **Z5:** (VO2max)
- **Ritmo de umbral (Z4):**

### 3.5 Nutrición

- **Tolerancia a entrenar con pocos carbohidratos:**
- **Sensibilidades digestivas:**
- **Fueling en carrera:** comida real o geles, g/h tolerados
- **Gut training:**

### 3.6 Fuerza, escalada y montaña

_Detalles metodológicos en las references de la skill: `strength.md`, `climbing.md`, `alpinism.md`._

- **Fuerza/Core:** días por semana, foco actual, cargas de referencia y dominadas estrictas
- **Escalada:** frecuencia, tipo (boulder, deportiva, vía larga), nivel máximo (redpoint/flash), prioridad, historial de dedos y poleas
- **Montaña con mochila:** salidas de referencia, desnivel y peso de mochila habitual
- **Material:** botas, bastones (experiencia), reloj y ecosistema
- **Alpinismo:** objetivos, experiencia y altitud

### 3.7 Calendario de carreras

_Las fechas son necesarias para periodizar y hacer el taper._

| Fecha | Nombre | Distancia | D+ | Tipo | Prioridad |
| ----- | ------ | --------- | -- | ---- | --------- |
|       |        |           |    |      | A/B/C     |

### 3.8 Estado actual

_Contexto vivo del estado físico y del foco del microciclo. Actualizar a menudo._

- **Última actualización:**
- **Fase:** Transición, Base, Específica, Taper o Recuperación
- **Volumen reciente:**
- **Foco:**

### 3.9 Observaciones

_Problemas detectados, patrones y señales positivas. Anota siempre la fecha para saber si siguen vigentes._

- (fecha) Observación

### 3.10 Datos por completar

_Datos que faltan. Pregúntalos cuando sean relevantes y pásalos al apartado que corresponda._

-

---

## Bloque «Contexto del atleta» de cada rutina

Cada rutina del informe empieza con un callout que repite solo los datos del perfil que le afectan. Cada línea cita el apartado de origen.

```markdown
### 6.1 Nombre de la rutina

> [!info] Contexto del atleta (§3)
> - **Tema:** dato que afecta a esta rutina (§3.x).
```

Qué incluir según el tipo de rutina:

| Rutina | Datos del perfil |
| ------ | ---------------- |
| Fuerza de pierna o fullbody | Lesiones y reglas de dolor (3.1), estructura semanal (3.2) |
| Fuerza de torso | Escalada y tirón ya cubiertos (3.6), recuperación (3.3) |
| Cinta, stepper o cardio | Zonas de FC y métricas (3.3 y 3.4), referencias de ascenso, impacto permitido (3.1) |
| Tirada larga o salida de montaña | Disponibilidad (3.2), ritmo en montaña (3.3), nutrición (3.5), material y bastones (3.6) |
| Core y movilidad | Escalada (3.6), lesiones que condicionan el ejercicio (3.1), adherencia (3.2) |
| Escalada | Nivel, historial de dedos y poleas (3.6), prioridad frente al resto (3.2) |

Si un dato cambia en el perfil, actualiza también los bloques que lo citan.
