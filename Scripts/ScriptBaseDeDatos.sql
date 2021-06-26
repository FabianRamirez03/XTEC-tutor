--Creacion de tablas de la base de datos
Create table Alumno (
	carnet varchar(20) not null,
	contrasena varchar(20) not null,
	correo varchar (100) not null,
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
	puntuacion decimal(3,1),
	descripcion varchar(max),
	visible bit not null,
	idCatalogo int not null,
	nombreArchivo varchar (100),
	extension varchar (100),
	archivo varchar (max),
	fechaCreacion date default getDate(),
	primary key (idEntrada)
);


Create table Vistas (
	idVista int identity (1,1),
	fechaVista date default getDate(),
	cantidadVistas int,
	idEntrada int,
	primary key (idVista),
	CONSTRAINT UC_vistas UNIQUE (idEntrada,fechaVista)
);


Create table EntradasAlumno(
	carnet varchar(20) not null,
	idEntrada int not null,
	primary key (carnet,idEntrada)
);

Create table Comentarios (
	idComentario int identity (1,1),
	comentario varchar(max) not null,
	fechaComentario datetime default getDate(),
	carnetAlumno varchar(20) not null,
	idEntrada int,
	primary key (idComentario)
);


Create table ReviewsAlumnos (
	carnet varchar(20) not null,
	idEntrada int not null,
	nota decimal(3,1),
	primary key (carnet, idEntrada)
);

Create table Administrador (
	usuario varchar(50),
	contrasena varchar (20),
	primary key (usuario)
);

Create table Catalogos (
	idCatalogo int identity (1,1),
	usuarioAdmin varchar (50),
	carrera varchar (100),
	curso varchar (100),
	tema varchar (100),
	primary key (idCatalogo)
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
Add constraint FK_idCatalogo
foreign key (idCatalogo) references Catalogos (idCatalogo);

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

Alter table Catalogos
Add constraint FK_usuarioAdmin
foreign key (usuarioAdmin) references Administrador (usuario);

Alter table Vistas
Add constraint FK_idEntradaVista
foreign key (idEntrada) references EntradaConocimiento (idEntrada);