--**************************ALUMNO**************************

--Agregar alumno
CREATE OR ALTER PROCEDURE agregarAlumno @carnet varchar(20), @contrasena varchar(20), @primerNombre varchar (20),
@apellido varchar (20), @correo varchar (100)
AS
Begin
INSERT INTO Alumno (carnet, contrasena, primerNombre, apellido, correo) values (@carnet, @contrasena, @primerNombre, @apellido, @correo);
End;
Go

--Agregar habilidades del alumno
CREATE OR ALTER PROCEDURE agregarHabilidad @carnet varchar (20), @habilidad varchar (200)
AS
BEGIN
	insert into HabilidadesAlumno values (@carnet,@habilidad);
END;
GO

--Ver habilidades del alumno
CREATE OR ALTER PROCEDURE verHabilidades @carnet varchar (20)
AS
BEGIN
	select habilidad from HabilidadesAlumno where carnet = @carnet;
END;
GO

CREATE OR ALTER PROCEDURE modificarHabilidades @carnet varchar (20), @habilidad varchar(200), @habilidadEditada varchar (200)
AS
BEGIN
	update HabilidadesAlumno set habilidad = @habilidadEditada where carnet = @carnet and habilidad = @habilidad;
END;
GO


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
	--En caso de ser administrador
	IF Exists (select * from Administrador where usuario = @usuario and contrasena = @contrasena)
	Begin
		set @tipoUsuario = 1;

	End;
	--En caso de ser alumno
	Else if Exists (select * from Alumno where carnet = @usuario and contrasena = @contrasena)
	Begin
		set @tipoUsuario = 2;
		select @tipoUsuario tipoUsuario, primerNombre, apellido, descripcion, sede, telefono, fechaUnion, fotografia, correo from Alumno where carnet = @usuario and contrasena = @contrasena;
		return;
	End;
	--En caso que no exista el usuario
	Else Begin
		set @tipoUsuario = 0;
	End;
	select @tipoUsuario tipoUsuario;
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
	BEGIN
		RAISERROR ('El carnet ingresado es invalido',16,1);
	END;
END;
GO

--Devuelve el ID de la ultima entrada creada por un alumno
CREATE OR ALTER PROCEDURE obtenerUltimaEntrada AS
BEGIN
	select top 1 idEntrada from EntradasAlumno order by idEntrada desc;
END;
GO


--Editar entrada de conocimiento
	CREATE OR ALTER PROCEDURE EditarEntradaConocimiento  @idEntrada int, @titulo varchar (100), @cuerpoArticulo varchar(max),
	@descripcion varchar (max), @nombreArchivo varchar (100), @extension varchar (100), @archivo varchar(max),
	@carrera varchar (100), @curso varchar(100), @tema varchar(100)
AS
BEGIN
	Declare @idCatalogo int = (select idCatalogo  from Catalogos where Carrera = @carrera and Curso = @curso and tema = @tema);
	If (@archivo = '')
	BEGIN
		Update EntradaConocimiento set titulo = @titulo, cuerpoArticulo = @cuerpoArticulo, descripcion = @descripcion, idCatalogo = @idCatalogo, fechaCreacion = getDate()
		where idEntrada = @idEntrada;	
	END;
	ELSE
	BEGIN
		Update EntradaConocimiento set titulo = @titulo, cuerpoArticulo = @cuerpoArticulo, descripcion = @descripcion, nombreArchivo = @nombreArchivo, extension = @extension, archivo = @archivo, idCatalogo = @idCatalogo, fechaCreacion = getDate()
		where idEntrada = @idEntrada;	
	END;
END;
GO

--Obtiene todos los datos de la entrada de conocimiento e indica si existe un archivo en esta
CREATE OR ALTER PROCEDURE obtenerEntrada @idEntrada int
AS
BEGIN
	Declare @cantidadVistas int = (select sum (cantidadVistas) from Vistas where idEntrada = @idEntrada);
	Declare @existeArchivo bit;
	IF (select archivo from EntradaConocimiento where idEntrada = @idEntrada) = ''
	BEGIN
		set @existeArchivo = 0;
	END;
	ELSE
	BEGIN
		set @existeArchivo = 1
	END;
	select ec.idEntrada, titulo,cuerpoArticulo, @cantidadVistas cantidadVistas, puntuacion, ec.descripcion, visible, nombreArchivo, fechaCreacion, @existeArchivo existeArchivo, a.carnet, primerNombre, apellido from EntradaConocimiento as ec
	inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
	inner join Alumno as a on a.carnet = ea.carnet
	where ec.idEntrada = @idEntrada;
END;
GO

--Obtiene el archivo de una entrada en especifico
CREATE OR ALTER PROCEDURE descargarArchivo @idEntrada int
AS
BEGIN
	select archivo, extension, nombreArchivo from EntradaConocimiento where idEntrada = @idEntrada;
END;
GO

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
	select ec.idEntrada, ec.titulo, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) vistas , ec.puntuacion, ec.descripcion, ec.visible, c.carrera,c.curso,c.tema from EntradaConocimiento ec 
	inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
	inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
	inner join Vistas as v on v.idEntrada = ec.idEntrada
	where ea.carnet = @carnet
	group by ec.idEntrada,ec.titulo,ec.puntuacion,ec.descripcion,ec.visible,c.carrera,c.curso,c.tema
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
		IF @carrera = '' and @curso = '' and @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by ec.fechaCreacion desc;
		END;

		ELSE IF @curso = '' and @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by ec.fechaCreacion desc;
		END;

		ELSE IF @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and c.curso = @curso and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by ec.fechaCreacion desc;
		END;

		ELSE
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and c.curso = @curso and c.tema = @tema and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by ec.fechaCreacion desc;
		END;
	End;
	
	--Busqueda por relevancia
	Else If (@tipoBusqueda = 0)
	Begin
			IF @carrera = '' and @curso = '' and @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by relevancia desc;
		END;

		ELSE IF @curso = '' and @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by relevancia desc;
		END;

		ELSE IF @tema = ''
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and c.curso = @curso and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by relevancia desc;
		END;

		ELSE
		BEGIN
			select titulo, ec.descripcion, (select sum(cantidadVistas) from Vistas where idEntrada = ec.idEntrada) as cantidadVistas, (select count (*) from Comentarios where ec.idEntrada = idEntrada) cantidadComentarios, puntuacion,
			fechaCreacion, ec.idEntrada, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema from EntradaConocimiento as ec
			inner join Catalogos as c on c.idCatalogo = ec.idCatalogo
			inner join Vistas as v on v.idEntrada = ec.idEntrada
			inner join EntradasAlumno as ea on ea.idEntrada = ec.idEntrada
			inner join Alumno as a on a.carnet = ea.carnet
			where c.carrera = @carrera and c.curso = @curso and c.tema = @tema and visible = 1
			group by ec.titulo,ec.descripcion, ec.idEntrada, puntuacion, fechaCreacion, ec.relevancia, a.primerNombre, a.apellido, c.carrera, c.curso,c.tema
			order by relevancia desc;
		END;
	END;
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
CREATE OR ALTER PROCEDURE puntuarEntrada (@carnet varchar (20), @idEntrada int, @nota decimal(3,1))
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


--Ver comentarios y notas de la entrada de conocimiento
CREATE OR ALTER PROCEDURE verReviewsEntrada ( @idEntrada int)
AS
BEGIN
	select a.primerNombre, a.apellido, c.comentario, ra.nota, a.fotografia, c.fechaComentario from Comentarios as c
	inner join Alumno as a on a.carnet = c.carnetAlumno
	inner join ReviewsAlumnos as ra on ra.carnet = a.carnet
	where c.idEntrada = @idEntrada and ra.idEntrada = @idEntrada
	order by c.fechaComentario desc;
END;
GO


--Aumenta las vistas de una entrada de conocimiento en 1
CREATE OR ALTER PROCEDURE agregarVista (@idEntrada int)
AS
BEGIN
	DECLARE @fecha date = getDate();
	IF EXISTS (select idVista from Vistas where idEntrada = @idEntrada and fechaVista = @fecha)
	Begin
		UPDATE Vistas set cantidadVistas = cantidadVistas + 1 where idEntrada = @idEntrada and fechaVista = @fecha;
	End;
	ELSE
	BEGIN
		INSERT into Vistas (fechaVista,cantidadVistas,idEntrada) values (@fecha,1,@idEntrada);
	END
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

--Trigger para inicializar las vistas de una entrada en 0 despues de ser creada
CREATE OR ALTER TRIGGER tr_vistasEntrada on EntradaConocimiento
after insert
as
begin
	declare @idEntrada int = (select idEntrada from inserted);
	insert into Vistas (cantidadVistas,idEntrada) values (0,@idEntrada);
end;
go

--Trigger para actualizar el indice de relevancia si se actualizan las vistas de alguna entrada
CREATE OR ALTER TRIGGER tr_relevanciaVistas on Vistas
after insert, update
as
begin
	declare @idEntrada int = (select idEntrada from inserted);
	declare @views12Meses int = (select sum (cantidadVistas)  from Vistas where idEntrada = @idEntrada and (DATEDIFF(MONTH,fechaVista,GETDATE()) <= 12));
	declare @views6Meses int = (select sum (cantidadVistas)  from Vistas where idEntrada = @idEntrada and (DATEDIFF(MONTH,fechaVista,GETDATE()) <= 6));
	declare @cantComentarios int = (select count (comentario) from Comentarios where idEntrada = @idEntrada);
	declare @relevancia int = 0;

	select @relevancia
	
	--Views en los ultimos 6 meses
	IF (@views6Meses != 0)BEGIN
		IF (@views6Meses >= 1 and @views6Meses < 5) BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF (@views6Meses >= 5 and @views6Meses < 10) BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF (@views6Meses >= 10 and @views6Meses < 20) BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF (@views6Meses >= 20 and @views6Meses < 30) BEGIN
			set @relevancia = @relevancia + 20;
		END;
		ELSE IF (@views6Meses >= 30 and @views6Meses < 50) BEGIN
			set @relevancia = @relevancia + 25;
		END;
		ELSE IF (@views6Meses >= 50) BEGIN
			set @relevancia = @relevancia + 30;
		END;
	END;
	select @relevancia
	
	--Views en los ultimos 12 meses
	IF (@views12Meses != 0)BEGIN
		IF (@views12Meses >= 1 and @views12Meses < 10) BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF (@views12Meses >= 10 and @views12Meses < 50) BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF (@views12Meses >= 50 and @views12Meses < 100) BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF (@views12Meses >= 100) BEGIN
			set @relevancia = @relevancia + 20;
		END;
	END;
	select @relevancia

	--Cantidad de comentarios
	IF (@cantComentarios != 0) BEGIN
		IF(@cantComentarios >= 1 and @cantComentarios < 5)BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF(@cantComentarios >= 5 and @cantComentarios < 10)BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF(@cantComentarios >= 10 and @cantComentarios < 50)BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF(@cantComentarios >= 50)BEGIN
			set @relevancia = @relevancia + 20;
		END;
	END;
	select @relevancia

	set @relevancia = @relevancia + (select puntuacion from EntradaConocimiento where idEntrada = @idEntrada) * 3;
	select @relevancia
	update EntradaConocimiento set relevancia = @relevancia where idEntrada = @idEntrada;
End;
Go

--Trigger en caso de comentar y puntuar
CREATE OR ALTER TRIGGER tr_relevanciaReviews on ReviewsAlumnos
after insert, update
as
begin
	declare @idEntrada int = (select idEntrada from inserted);
	declare @views12Meses int = (select sum (cantidadVistas)  from Vistas where idEntrada = @idEntrada and (DATEDIFF(MONTH,fechaVista,GETDATE()) <= 12));
	declare @views6Meses int = (select sum (cantidadVistas)  from Vistas where idEntrada = @idEntrada and (DATEDIFF(MONTH,fechaVista,GETDATE()) <= 6));
	declare @cantComentarios int = (select count (comentario) from Comentarios where idEntrada = @idEntrada);
	declare @relevancia int = 0;

	select @relevancia
	
	--Views en los ultimos 6 meses
	IF (@views6Meses != 0)BEGIN
		IF (@views6Meses >= 1 and @views6Meses < 5) BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF (@views6Meses >= 5 and @views6Meses < 10) BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF (@views6Meses >= 10 and @views6Meses < 20) BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF (@views6Meses >= 20 and @views6Meses < 30) BEGIN
			set @relevancia = @relevancia + 20;
		END;
		ELSE IF (@views6Meses >= 30 and @views6Meses < 50) BEGIN
			set @relevancia = @relevancia + 25;
		END;
		ELSE IF (@views6Meses >= 50) BEGIN
			set @relevancia = @relevancia + 30;
		END;
	END;
	select @relevancia
	
	--Views en los ultimos 12 meses
	IF (@views12Meses != 0)BEGIN
		IF (@views12Meses >= 1 and @views12Meses < 10) BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF (@views12Meses >= 10 and @views12Meses < 50) BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF (@views12Meses >= 50 and @views12Meses < 100) BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF (@views12Meses >= 100) BEGIN
			set @relevancia = @relevancia + 20;
		END;
	END;
	select @relevancia

	--Cantidad de comentarios
	IF (@cantComentarios != 0) BEGIN
		IF(@cantComentarios >= 1 and @cantComentarios < 5)BEGIN
			set @relevancia = @relevancia + 5;
		END;
		ELSE IF(@cantComentarios >= 5 and @cantComentarios < 10)BEGIN
			set @relevancia = @relevancia + 10;
		END;
		ELSE IF(@cantComentarios >= 10 and @cantComentarios < 50)BEGIN
			set @relevancia = @relevancia + 15;
		END;
		ELSE IF(@cantComentarios >= 50)BEGIN
			set @relevancia = @relevancia + 20;
		END;
	END;
	select @relevancia

	set @relevancia = @relevancia + (select puntuacion from EntradaConocimiento where idEntrada = @idEntrada) * 3;
	select @relevancia
	update EntradaConocimiento set relevancia = @relevancia where idEntrada = @idEntrada;
End;
Go
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

--Funcion para limpiar los casos de prueba de la base
CREATE OR ALTER PROCEDURE limpiarBase
AS
BEGIN
	delete from Vistas;
	delete from EntradasAlumno;
	delete from Comentarios;
	delete from ReviewsAlumnos
	delete from EntradaConocimiento;
END;
GO

--Funcion para importar alumnos a partir de una hoja de excel, el nombre Hoja1$ es el nombre con el que se importa la tabla de excel
Create or Alter PROCEDURE importarExcel AS
BEGIN
	INSERT into Alumno (carnet,primerNombre, apellido, contrasena, correo, telefono) select * from Hoja1$;
	DROP TABLE Hoja1$;
END;
GO

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

