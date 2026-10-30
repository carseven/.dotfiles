# Modo «Sync» — sincronizar datos y revisar el plan

Objetivo: traer los datos reales desde la última actualización, registrarlos en el plan, compararlos con lo prescrito y **proponer «sin cambios» o modificaciones concretas**.

Regla principal: registras datos sin pedir permiso, pero no cambias nada de lo prescrito sin la aprobación del atleta.

| Se escribe sin pedir permiso (datos medidos) | Requiere aprobación (decisiones) |
| -------------------------------------------- | -------------------------------- |
| Tabla semanal de km, D+ y km-esfuerzo | Cambiar rutinas, series, cargas o repeticiones |
| «Última actualización» y estado de las semanas pasadas | Mover o quitar sesiones |
| Apartado 3.8 «Estado actual» | Cambiar fases o fechas |
| Observaciones nuevas con fecha (3.9) | Cambiar zonas de FC (3.4) o reglas de dolor (3.1) |
| Métricas medidas nuevas (3.3), con fuente y fecha | Cambiar el objetivo o su prioridad |

---

## 1. Cargar el plan

1. Resolver `<coach_dir>` según `SKILL.md` («Resultados — vault de Obsidian»).
2. Usa el plan que eligió el atleta. Si no eligió ninguno y hay varios, pregunta cuál.
3. Lee el perfil (§3), el calendario de semanas, las rutinas y la tabla semanal. No leas ni enlaces otros planes.

## 2. Ventana de datos

Desde la fecha de «Última actualización» del plan (o la última semana con datos en la tabla) hasta hoy. Dile al atleta el periodo que vas a cubrir.

## 3. Traer los datos

1. **Zepp:** ejecuta `doctor`. Si la caché no cubre el periodo, pide consentimiento y ejecuta `sync`. Ver `SKILL.md` («Zepp Life — caché local»).
2. **Strava:** lee las actividades del periodo en el navegador. El D+ de la cinta está en el título. La fuerza viene de la actividad de Hevy. Ver `SKILL.md` («Strava — Segunda fuente de entrenos»).
3. **Atleta:** para los huecos, pregunta por dolor o molestias (0-10), sueño, enfermedad y viajes.

Une las actividades de Strava y Zepp por fecha y duración. No cuentes dos veces un día de fuerza. Si falta un dato, dilo. No lo inventes. No pidas ni leas un `apptoken`.

## 4. Registrar los datos en el plan

Escribe solo lo de la columna izquierda de la tabla de arriba:

1. Añade las semanas cerradas (lunes a domingo) a la tabla semanal. Actualiza el total y la tabla de máximos frente al objetivo.
2. Actualiza el estado de las semanas pasadas: hecha, parcial o perdida.
3. Actualiza 3.8 «Estado actual» y la fecha de «Última actualización».
4. Añade observaciones con fecha en 3.9, y las métricas medidas nuevas en 3.3.

## 5. Comparar con el plan

| Área | Qué comparar |
| ---- | ------------ |
| Adherencia | Sesiones planificadas frente a hechas, por rutina |
| Carga | Volumen y D+ de la semana frente al plan y frente a la semana anterior (máximo +10%). ACWR de `methodology.md` §4. Km-esfuerzo = km + D+/100 |
| Intensidad | Parte del tiempo en Z1-Z2 y FC de cada sesión frente a las zonas del perfil (3.4) |
| Recuperación | FC de reposo frente a la base (3.3), sueño, HRV si existe. Señales de sobreentrenamiento de `methodology.md` §5 |
| Fuerza | Mismos ejercicios entre sesiones: carga, repeticiones totales y RPE |
| Dolor | Reglas de dolor del perfil (3.1) |
| Hitos | Pruebas y simulacros: ¿cumplió los criterios? |
| Meta | Máximos conseguidos frente a lo que exige el objetivo |

## 6. Decidir

**Sin cambios** cuando la adherencia es razonable, la carga sigue la progresión, no hay señales de fatiga ni dolor sobre el umbral del perfil, y los hitos van bien.

**Proponer modificaciones** cuando hay alguno de estos casos:

- Semanas perdidas o incumplimiento relevante.
- Un salto de carga mayor del 10%.
- Señales de fatiga, enfermedad o mala recuperación.
- Dolor por encima del umbral del perfil.
- Fuerza estancada o en regresión sin motivo deliberado.
- Un hito no cumplido.
- Un cambio de disponibilidad, de objetivo o de fecha.

Con síntomas de alarma (dolor agudo, marcha alterada, dolor torácico, desmayo, falta de aire intensa), recomienda parar y buscar valoración médica.

## 7. Informe al atleta

Presenta un informe compacto:

1. **Datos y alcance:** periodo, fuentes y huecos.
2. **Registrado en el plan:** lista breve de lo que escribiste.
3. **Estado frente al plan:** tabla de rutina o semana, planificado, hecho y nota.
4. **Conclusión:**
   - «Sin cambios», con el motivo en una o dos frases, o
   - «Propuestas», numeradas y priorizadas (máximo 3-5). Cada una indica el cambio, el dato que la motiva, la sección del plan que cambiaría y el riesgo.
5. **Decisión:** pide al atleta que apruebe todas, elija algunas o no cambie nada. Usa la herramienta de preguntas si está disponible, con una opción por propuesta y una opción «Sin cambios».

## 8. Aplicar solo lo aprobado

1. Edita las rutinas o la periodización aprobadas. Actualiza el apartado 3 y los bloques «Contexto del atleta» que citen datos cambiados.
2. Añade al final del informe una sección «Ajuste del plan — <fecha>» con estos subapartados: Datos y alcance, Qué muestran los datos, Decisiones acordadas con el atleta y Pendiente.
3. Si la conclusión es «Sin cambios» o el atleta no aprueba nada, añade una observación con fecha en 3.9: periodo y conclusión, en una o dos líneas.
4. Si existe `calendario.ics` y cambian sesiones, ofrece regenerarlo con la skill `ical`.
5. Solo el plan activo. No toques otros planes.

## 9. Cierre

Termina con el siguiente paso concreto y la fecha recomendada para el próximo Sync, por ejemplo el próximo lunes.
