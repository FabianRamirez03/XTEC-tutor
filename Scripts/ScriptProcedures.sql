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
CREATE OR ALTER PROCEDURE crearEntradaConocimiento @titulo varchar (100), @cuerpoArticulo varchar(max),
@descripcion varchar (max), @visible bit, @nombreArchivo varchar (100), @extension varchar (100), @archivo varchar(max),
@carrera varchar (100), @curso varchar(100), @tema varchar(100)
AS
BEGIN
	Declare @idCatalogo int = (select idCatalogo  from Catalogos where Carrera = @carrera and Curso = @curso and tema = @tema);
	INSERT INTO EntradaConocimiento (titulo,cuerpoArticulo,descripcion,visible,nombreArchivo,extension,archivo,idCatalogo)
	values (@titulo,@cuerpoArticulo, @descripcion, @visible, @nombreArchivo, @extension,@archivo,@idCatalogo);
END;
GO

--Buscar entradas de conocimiento
CREATE OR ALTER PROCEDURE buscarEntradas (@carrera varchar (100), @curso varchar (100), @tema varchar(100),
@tipoBusqueda bit)
AS
BEGIN
	IF (@tipoBusqueda == 1)
	Begin
		select * from EntradaConocimiento where Carrera = @carrera and Curso = @curso and tema = @tema
		order by puntuacion;
	End
	Else If (@tipoBusqueda == 0)
	Begin
		select * from EntradaConocimiento where Carrera = @carrera and Curso = @curso and tema = @tema
	End
END;
GO


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

