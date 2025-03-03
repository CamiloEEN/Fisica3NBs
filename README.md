# Fisica3NBs

## Notas de Clase: Curso Introductorio de Electromagnetismo

Bienvenido a mi repositorio de **notas de clase** para el curso **Física 3** que imparto en la **Universidad del Ibagué**. Este curso está diseñado como una introducción al **electromagnetismo** y tiene como objetivo proporcionar a los estudiantes una comprensión sólida de los conceptos fundamentales de esta disciplina.

### Descripción

En este repositorio se encuentran las **notas de clase interactivas** elaboradas en **notebooks de Pluto** utilizando el lenguaje de programación **Julia**. El uso de Pluto permite que las notas sean **interactivas**, facilitando el aprendizaje al proporcionar ejemplos dinámicos, visualizaciones y ejercicios en tiempo real.

### Objetivo

El principal objetivo de este proyecto es ofrecer una herramienta educativa accesible y fácil de seguir para los estudiantes, permitiéndoles:
- **Entender conceptos clave de electromagnetismo**.
- **Interaccionar con ejemplos y visualizaciones** en tiempo real.
- **Explorar los temas de manera práctica** con el soporte del lenguaje de programación Julia.

### Estado del Proyecto

Este es un proyecto **personal** y actualmente **está en progreso**. Se seguirán agregando más temas, ejemplos y ejercicios a medida que avance el curso.

### ⚠️ Advertencia  
Estas notas no pretenden sustituir un libro de texto. La notación utilizada sigue la del libro *Elementos de Electromagnetismo* de Sadiku, que es el libro guía del curso.  

Para un lector con bases más sólidas en cálculo y que desee profundizar en electromagnetismo, recomiendo *Modern Electrodynamics* de Zangwill.  

Estas notas están diseñadas como material de apoyo interactivo utilizando notebooks de **Pluto.jl**.

---

### Estructura del Repositorio

- **Notebooks de Pluto**: En esta carpeta se encuentran los notebooks con las notas interactivas.
- **Ejemplos y ejercicios**: Algunos notebooks incluyen ejemplos prácticos y problemas resueltos.
- **Referencias y recursos**: En el futuro, se añadirán materiales adicionales como enlaces a libros, artículos y videos relevantes.

### Requisitos

Para visualizar y trabajar con las notas interactivas, necesitarás tener instalado:

- **Julia**: El lenguaje de programación usado para los notebooks.
- **Pluto.jl**: La librería para crear y ejecutar los notebooks interactivos. 

Para instalar **Pluto.jl**, sigue estos pasos:

1. Instala Julia desde [aquí](https://julialang.org/downloads/).
2. En la terminal de Julia, ejecuta:

   ```julia
   using Pkg
   Pkg.add("Pluto")

3. Para abrir los notebooks, simplemente ejecuta:

    ```julia
   using Pluto
   Pluto.run()

### Ajustes Manuales y Arreglos Temporales
Hay un inconveniente al graficar con la función arrow() usando CairoMakie en 3D. La función siempre crea la flecha de vector utilizando el parametro position como centro de la flecha y no como inicio, razón por la cual los vectores unitarios mostrados en las gráficas tuvieron que ajustarse manualmente. Para más información sobre esto y otros inconvenientes que puedan ocurrir, se puede consultar la siguiente lista [Issues](https://github.com/MakieOrg/Makie.jl/issues?q=state%3Aopen%20label%3A%22arrows%22)

### Contribuciones

Este proyecto es de **código abierto**, por lo que cualquier sugerencia, corrección o mejora es bienvenida. Si deseas contribuir, por favor, sigue estos pasos:

1. Haz un fork de este repositorio.
2. Crea una rama con tus cambios (`git checkout -b feature-nueva`).
3. Haz commit de tus cambios (`git commit -am 'Agrega nueva función'`).
4. Envía un pull request.

### Licencia

Este proyecto está bajo la **Licencia MIT**.
