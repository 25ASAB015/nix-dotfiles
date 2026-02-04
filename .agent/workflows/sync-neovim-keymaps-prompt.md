Usa /home/ludus/Dotfiles/.agent/workflows/sync-neovim-keymaps.md 
para ACTUALIZAR ITERATIVAMENTE (no reemplazar) la documentación.

ARCHIVO: /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx

MODO: ITERATIVO Y PRESERVATIVO

Proceso del PASO 6:
1. BACKUP automático con timestamp
2. LEER archivo actual completamente
3. ANALIZAR secciones y keymaps existentes
4. EXTRAER keymaps del source khanelivim
5. COMPARAR e identificar faltantes
6. ACTUALIZAR por sección:
   - Crear secciones nuevas
   - Agregar keymaps faltantes a existentes
   - Actualizar descripciones si cambiaron
   - PRESERVAR todo lo demás
7. VERIFICAR integridad (paso 6.7)
8. GENERAR reporte detallado (paso 6.8)

REGLAS ESTRICTAS:
- ❌ NUNCA reemplazar archivo completo
- ✅ SIEMPRE preservar contenido existente
- ✅ SOLO agregar/actualizar lo necesario
- ✅ MANTENER formato y estructura
- ✅ VERIFICAR que conteo aumenta
- ✅ GENERAR reporte de cambios
