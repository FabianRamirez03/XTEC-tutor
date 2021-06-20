/*
execute agregarAlumno @carnet = '201868978' , @contrasena = '98845', @primerNombre = 'Paco',
@apellido = 'Rodriguez', @correo = 'correoPrueba2@gmail.com'
*/

/*
execute agregarAdmin @usuario = 'admin',@contrasena ='admin'
*/

/*
execute iniciarSesion @usuario = '2018319178', @contrasena = '123456'
*/

/*
execute editarPerfil @carnet = '2018319178', @contrasena = '11111', @correo = 'nuevoCorreo@gmail.com',
@primerNombre = 'Pablo', @apellido = 'Alvarado', @descripcion = 'wao pero ud tiene o no tiene',
@telefono = '98512787', @fotografia = 'no tengo jeje'
*/

/*
execute crearCatalogo @usuarioAdmin = 'admin', @carrera = 'Carrera de prueba 2', @curso = 'Curso de prueba 2',
@tema = 'tema de prueba 2'

execute crearCatalogo @usuarioAdmin = 'admin', @carrera = 'computadores', @curso = '',
@tema = ''

execute crearCatalogo @usuarioAdmin = 'admin', @carrera = 'computadores', @curso = 'intro y taller',
@tema = ''
*/

/*
execute crearEntradaConocimiento @carnet = '2018319178', @titulo = 'Titulo de prueba 4', @cuerpoArticulo = 'Cuerpo de prueba 4',
@descripcion = 'Descripcion de prueba 4', @visible = 1, @nombreArchivo = 'nombre de prueba 4',
@extension = '.png', @archivo = 'aqui iria el archivo', @carrera = 'Carrera de prueba',
@curso = 'Curso de prueba' , @tema = 'tema de prueba'

execute crearEntradaConocimiento @carnet = '2018319178', @titulo = 'articulo sin curso ni tema', @cuerpoArticulo = 'Cuerpo de prueba',
@descripcion = 'Descripcion de prueba', @visible = 1, @nombreArchivo = 'nombre de prueba',
@extension = '.png', @archivo = 'aqui iria el archivo', @carrera = 'computadores',
@curso = '' , @tema = ''

execute crearEntradaConocimiento @carnet = '2018319178', @titulo = 'articulo sin tema', @cuerpoArticulo = 'Cuerpo de prueba',
@descripcion = 'Descripcion de prueba', @visible = 1, @nombreArchivo = 'nombre de prueba',
@extension = '.png', @archivo = 'aqui iria el archivo', @carrera = 'computadores',
@curso = 'intro y taller' , @tema = ''
*/

/*
execute verEntradasAlumno @carnet = '2018319178'
*/

/*
execute buscarEntradas @carrera ='Carrera de prueba',@curso = 'Curso de prueba',@tema ='tema de prueba',@tipoBusqueda = 1

execute buscarEntradas @carrera ='computadores', @curso = '',@tema ='',@tipoBusqueda = 1

execute buscarEntradas @carrera ='computadores',@curso = 'intro y taller',@tema ='',@tipoBusqueda = 1
*/

/*
execute comentarEntrada @carnet = '2018319178' ,@idEntrada = 5, @comentario = 'Me parecio muy buen articulo'
execute comentarEntrada @carnet = '2018319178' ,@idEntrada = 5, @comentario = 'Siga subiendo articulos asi'
execute comentarEntrada @carnet = '201868978' ,@idEntrada = 5, @comentario = 'no me quedo del todo claro'
execute comentarEntrada @carnet = '2018319178' ,@idEntrada = 7, @comentario = 'Que es este articulo tan malo?'
*/
select * from EntradaConocimiento
select * from ReviewsAlumnos
delete from ReviewsAlumnos where idEntrada = 5
update EntradaConocimiento set puntuacion = 
/*
execute puntuarEntrada @carnet = '2018319178', @idEntrada = 5, @nota = 9;
execute puntuarEntrada @carnet = '201868978', @idEntrada = 5, @nota = 6;
execute puntuarEntrada @carnet = '2018319178', @idEntrada = 7, @nota = 2;
*/
select * from Alumno
/*
execute verReviewsEntrada @idEntrada = 5
*/

