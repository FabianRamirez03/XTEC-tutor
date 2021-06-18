--Creacion de tablas de la base de datos
Create table Alumno (
	carnet varchar(20),
	contrasena varchar(20) not null,
	correro varchar (100) not null,
	primerNombre varchar(20) not null,
	apellido varchar (20) not null,
	descripcion varchar (200),
	sede varchar (100) default 'Central Cartago',
	telefono varchar (20),
	fechaUnion datetime default getDate(),
	fotografia varchar(max),
	primary key (carnet)
);

Create table HabilidadesAlumno (
	carnet varchar(20) not null,
	habilidad varchar (200) not null,
	primary key (carnet, habilidad)
);

Create table EntradaConocimiento (
	idEntrada int identity (1,1),
	titulo varchar (100) not null,
	cuerpoArticulo varchar(max),
	vistas int default 0,
	puntuacion int default 0,
	descripcion varchar(max),
	nombreCarrera varchar (100) not null,
	primary key (idEntrada)
);


Create table EntradasAlumno(
	carnet varchar(20) not null,
	idEntrada int not null,
	primary key (carnet,idEntrada)
);

Create table Comentarios (
	idComentario int identity (1,1),
	comentario varchar(max) not null,
	carnetAlumno varchar(20) not null,
	idEntrada int,
	primary key (idComentario)
);

Create table ReviewsAlumnos (
	carnet varchar(20) not null,
	idEntrada int not null,
	nota int,
	primary key (carnet, idEntrada)
);

Create table Administrador (
	usuario varchar(50),
	contrasena varchar (20),
	primary key (usuario)
);

Create table Carrera (
	nombreCarrera varchar (100),
	usuarioAdmin varchar (50),
	primary key (nombreCarrera)
);

Create table Curso (
	nombreCurso varchar (100),
	nombreCarrera varchar (100),
	primary key (nombreCurso, nombreCarrera)
);

Create table Tema (
	nombreTema varchar (100),
	nombreCurso varchar (100),
	nombreCarrera varchar (100),
	primary key (nombreTema, nombreCurso,nombreCarrera)
);

--Modificaciones de las tablas

Alter table HabilidadesAlumno
Add constraint FK_carnet
foreign key (carnet) references Alumno (carnet);

Alter table EntradasAlumno
Add constraint FK_carnetEntradasAlumno
foreign key (carnet) references Alumno (carnet);

Alter table EntradasAlumno
Add constraint FK_idEntradaAlumno
foreign key (idEntrada) references EntradaConocimiento (idEntrada);

Alter table EntradaConocimiento
Add constraint FK_nombreCarreraEntrada
foreign key (nombreCarrera) references Carrera (nombreCarrera);

Alter table ReviewsAlumnos
Add constraint FK_carnetReviews
foreign key (carnet) references Alumno (carnet);

Alter table ReviewsAlumnos
Add constraint FK_EntradaConocimiento
foreign key (idEntrada) references EntradaConocimiento (idEntrada);

Alter table Comentarios
Add constraint FK_carnetAlumnoComentario
foreign key (carnetAlumno) references Alumno (carnet);

Alter table Comentarios
Add constraint FK_idEntradaComentario
foreign key (idEntrada) references EntradaConocimiento (idEntrada);

Alter table Carrera
Add constraint FK_usuarioCarrera
foreign key (usuarioAdmin) references Administrador (usuario);

Alter table Curso
Add constraint FK_nombreCarrera
foreign key (nombreCarrera) references Carrera (nombreCarrera);

Alter table Tema
Add constraint FK_nombreCurso
foreign key (nombreCurso,nombreCarrera) references Curso (nombreCurso,nombreCarrera);