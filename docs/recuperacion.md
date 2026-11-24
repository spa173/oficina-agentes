# Recuperar la oficina anterior

El instalador devuelve la ruta del respaldo de cada operación que modifica archivos. El respaldo global queda por defecto bajo `%USERPROFILE%/.office-backups` y contiene los originales de los archivos modificados. Conserva el respaldo en tu equipo.

```powershell
./scripts/Restore-Office.ps1 -Scope Global -Backup '<ruta devuelta por el instalador>' -DryRun
./scripts/Restore-Office.ps1 -Scope Global -Backup '<ruta devuelta por el instalador>'
```

Si instalaste en un proyecto, usa `-Scope Project -Target <carpeta>` con el mismo destino de la instalación. La restauración verifica las huellas y se detiene ante una edición posterior de un archivo afectado. Se recuperan los archivos anteriores y se retiran los perfiles que sólo existían después de instalar. Abre una sesión nueva para volver a cargar la configuración.
