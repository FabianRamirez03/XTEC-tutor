--**************************ALUMNO**************************

--Agregar alumno
CREATE OR ALTER PROCEDURE agregarAlumno @carnet varchar(20), @contrasena varchar(20), @primerNombre varchar (20),
@apellido varchar (20), @correo varchar (100)
AS
Begin
INSERT INTO Alumno (carnet, contrasena, primerNombre, apellido, correo) values (@carnet, @contrasena, @primerNombre, @apellido, @correo);
End;
Go

--Editar perfil
CREATE OR ALTER PROCEDURE editarPerfil @carnet varchar(20), @contrasena varchar(20), @correo varchar(100), @primerNombre varchar(20),
@apellido varchar (20), @descripcion varchar (200), @telefono varchar (20), @fotografia varchar (max)
AS
Begin
update Alumno set contrasena = @contrasena, correo = @correo, primerNombre = @primerNombre, apellido = @apellido,
descripcion = @descripcion, telefono = @telefono, fotografia = @fotografia where carnet = @carnet;
End;
Go

--Validar inicio de sesion
CREATE OR ALTER PROCEDURE iniciarSesion @usuario varchar(50), @contrasena varchar(20)
AS
Begin
	DECLARE @tipoUsuario int;
	IF Exists (select * from Administrador where usuario = @usuario and contrasena = @contrasena)
	Begin
		set @tipoUsuario = 1;
	End;
	Else if Exists (select * from Alumno where carnet = @usuario and contrasena = @contrasena)
	Begin
		set @tipoUsuario = 2;
	End;
	Else Begin
		set @tipoUsuario = 0;
	End;
	return @tipoUsuario;
End;
Go

--Crear entrada de conocimiento
CREATE OR ALTER PROCEDURE crearEntradaConocimiento @carnet varchar (20), @titulo varchar (100), @cuerpoArticulo varchar(max),
@descripcion varchar (max), @visible bit, @nombreArchivo varchar (100), @extension varchar (100), @archivo varchar(max),
@carrera varchar (100), @curso varchar(100), @tema varchar(100)
AS
BEGIN
	Declare @idCatalogo int = (select idCatalogo  from Catalogos where Carrera = @carrera and Curso = @curso and tema = @tema);
	if exists (select * from Alumno where carnet = @carnet)
	Begin
		INSERT INTO EntradaConocimiento (titulo,cuerpoArticulo,descripcion,visible,nombreArchivo,extension,archivo,idCatalogo)
		values (@titulo,@cuerpoArticulo, @descripcion, @visible, @nombreArchivo, @extension,@archivo,@idCatalogo);
		INSERT INTO EntradasAlumno values (@carnet, scope_identity());
	end;
	else
		RAISERROR ('El carnet ingresado es invalido',16,1);
END;
GO



--Obtiene todos los datos de la entrada de conocimiento e indica si existe un archivo en esta
CREATE OR ALTER PROCEDURE obtenerEntrada @idEntrada int
AS
BEGIN
	IF (select archivo from EntradaConocimiento where idEntrada = @idEntrada) = ''
	BEGIN
		select idEntrada, titulo,cuerpoArticulo, vistas, puntuacion, descripcion, visible, nombreArchivo, fechaCreacion, 0 existeArchivo from EntradaConocimiento where idEntrada = @idEntrada;
	END;
	ELSE
	BEGIN
		select idEntrada, titulo,cuerpoArticulo, vistas, puntuacion, descripcion, visible, nombreArchivo, fechaCreacion, 1 existeArchivo from EntradaConocimiento where idEntrada = @idEntrada;
	END;
END;
GO

--Obtiene el archivo de una entrada en especifico
CREATE OR ALTER PROCEDURE descargarArchivo @idEntrada int
AS
BEGIN
	select archivo, extension, nombreArchivo from EntradaConocimiento where idEntrada = @idEntrada;
END;
GO
execute descargarArchivo @idEntrada = 21

--Habilitar o deshabilitar la visibilidad de un curso
CREATE OR ALTER PROCEDURE cambiarVisibilidad (@idEntrada int)
AS
BEGIN
	update EntradaConocimiento set visible = visible ^ 1 where idEntrada = @idEntrada;
END;
GO

--Ver entradas del alumno por su carnet
CREATE OR ALTER PROCEDURE verEntradasAlumno (@carnet varchar(20))
AS
BEGIN
	select ec.idEntrada, ec.titulo, ec.vistas, ec.puntuacion, ec.descripcion, ec.visible, c.carrera,c.curso,c.tema from EntradaConocimiento ec 
	inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
	inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
	where ea.carnet = @carnet;
END;
GO


--Buscar entradas de conocimiento
CREATE OR ALTER PROCEDURE buscarEntradas (@carrera varchar (100), @curso varchar (100), @tema varchar(100),
@tipoBusqueda bit)
AS
BEGIN
	--Busqueda por recientes
	IF (@tipoBusqueda = 1)
	Begin
		select titulo, descripcion, vistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
		fechaCreacion, ec.idEntrada from EntradaConocimiento as ec
		inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
		where c.carrera = @carrera and c.curso = @curso and c.tema = @tema and visible = 1
		group by ec.titulo,ec.descripcion,ec.vistas, idEntrada, puntuacion,fechaCreacion,ec.idEntrada
		order by ec.fechaCreacion desc;
	End

	--Busqueda por relevancia
	Else If (@tipoBusqueda = 0)
	Begin
		select titulo, descripcion, vistas, (select count (*) from Comentarios as com where ec.idEntrada = com.idEntrada) cantidadComentarios, puntuacion,
		fechaCreacion, ec.idEntrada from EntradaConocimiento as ec
		inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
		where c.carrera = @carrera and c.curso = @curso and c.tema = @tema and visible = 1
		group by ec.titulo,ec.descripcion,ec.vistas, idEntrada, puntuacion,fechaCreacion,ec.idEntrada
		order by ec.puntuacion desc;
	End
END;
GO

--Ver carreras
CREATE OR ALTER PROCEDURE verCarreras
AS
BEGIN
	select carrera from Catalogos group by carrera;
END;
GO

--Ver cursos por carrera
CREATE OR ALTER PROCEDURE verCursos (@carrera varchar (100))
AS
BEGIN
	select curso from Catalogos where carrera = @carrera and curso != '' group by curso;
END;
GO

--Ver temas por curso
CREATE OR ALTER PROCEDURE verTemas (@curso varchar (100))
AS
BEGIN
	select tema from Catalogos where curso = @curso and tema != '' group by tema;
END;
GO

--Comentar entrada de conocimiento
CREATE OR ALTER PROCEDURE comentarEntrada (@carnet varchar (20), @idEntrada int, @comentario varchar(max))
AS
BEGIN
	insert into Comentarios (comentario,carnetAlumno,idEntrada) values (@comentario, @carnet, @idEntrada)
END;
GO

--Puntuar entrada de conocimiento
CREATE OR ALTER PROCEDURE puntuarEntrada (@carnet varchar (20), @idEntrada int, @nota int)
AS
BEGIN
	if not exists (select * from ReviewsAlumnos where carnet = @carnet and idEntrada = @idEntrada)
	begin
		insert into ReviewsAlumnos(carnet,idEntrada, nota) values (@carnet, @idEntrada, @nota);
	end;
	else
	begin
		update ReviewsAlumnos set nota = @nota where carnet = @carnet and idEntrada = @idEntrada;
	end;
END;
GO

--Ver comentarios y notas de la entrada de conocimiento *****SOLO SE VEN SI SE PUSO NOTA Y SE COMENTÓ**********
CREATE OR ALTER PROCEDURE verReviewsEntrada ( @idEntrada int)
AS
BEGIN
	select a.primerNombre, a.apellido, c.comentario, ra.nota from Comentarios as c
	inner join Alumno as a on a.carnet = c.carnetAlumno
	inner join ReviewsAlumnos as ra on ra.carnet = a.carnet
	where c.idEntrada = @idEntrada and ra.idEntrada = @idEntrada;
END;
GO

--Aumenta las vistas de una entrada de conocimiento en 1
CREATE OR ALTER PROCEDURE agregarVista ( @idEntrada int)
AS
BEGIN
	UPDATE EntradaConocimiento set vistas = vistas + 1 where idEntrada = @idEntrada;
END;
GO

--****TRIGGERS****
--Trigger para puntuacion inicial en 0
CREATE OR ALTER TRIGGER tr_puntuacionPorDefecto on EntradaConocimiento
for insert
as
begin
	declare @idEntrada int = (select idEntrada from inserted);
	update EntradaConocimiento set puntuacion = 0.0 where idEntrada = @idEntrada;
end;
go

--Trigger para obtener las nota promedio a partir de las calificaciones de los alumnos en la entrada de conocimiento
CREATE OR ALTER TRIGGER tr_sumarNotaEntrada on ReviewsAlumnos
after insert, update
as
begin
	declare @idEntrada int = (select idEntrada from inserted);
	declare @cantidadVotos int = (select count(*) from ReviewsAlumnos where idEntrada = @idEntrada);
	declare @notaTotal decimal(3,1) = (select sum (nota) from ReviewsAlumnos where idEntrada = @idEntrada);
	update EntradaConocimiento set puntuacion = @notaTotal/@cantidadVotos where idEntrada = @idEntrada;
end;
go

--****TRIGGERS****
--**************************ALUMNO**************************


--**************************ADMINISTRADOR**************************
--Agregar administrador
CREATE OR ALTER PROCEDURE agregarAdmin @usuario varchar(50), @contrasena varchar(20)
AS
Begin
INSERT INTO Administrador values (@usuario, @contrasena);
End;
Go


--Crear Catalogo
CREATE OR ALTER PROCEDURE crearCatalogo @usuarioAdmin varchar(50), @carrera varchar(100), @curso varchar(100),
@tema varchar(100)
AS
Begin
INSERT INTO Catalogos (usuarioAdmin, carrera, curso, tema) values (@usuarioAdmin, @carrera, @curso, @tema);
End;
Go



--**************************ADMINISTRADOR**************************


--**************************HABILIDADES**************************

--Agregar habilidades alumno
CREATE OR ALTER PROCEDURE agregarHabilidades @carnet varchar(20), @habilidad varchar(200)
AS
Begin
INSERT INTO HabilidadesAlumno values (@carnet, @habilidad);
End;
Go

--Eliminar hablidades alumno
CREATE OR ALTER PROCEDURE eliminarHabilidades @carnet varchar(20), @habilidad varchar(200)
AS
Begin
DELETE FROM HabilidadesAlumno where carnet = @carnet and habilidad = @habilidad;
End;
Go

--**************************HABILIDADES**************************

