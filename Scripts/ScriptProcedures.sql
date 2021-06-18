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
End;
Go

--**************************ALUMNO**************************


--**************************ADMINISTRADOR**************************
--Agregar administrador
CREATE OR ALTER PROCEDURE agregarAdmin @usuario varchar(50), @contrasena varchar(20)
AS
Begin
INSERT INTO Administrador values (@usuario, @contrasena);
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

