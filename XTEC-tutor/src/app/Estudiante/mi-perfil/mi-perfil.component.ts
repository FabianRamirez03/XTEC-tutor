import {Component, OnInit} from '@angular/core';
import {FileService} from "../../_service/file.service";
import {DatePipe} from '@angular/common'

@Component({
  selector: 'app-mi-perfil',
  templateUrl: './mi-perfil.component.html',
  styleUrls: ['./mi-perfil.component.scss']
})
export class MiPerfilComponent implements OnInit {

  constructor(public fileService: FileService, public datepipe: DatePipe) { }
  listaEntradas:any;
  fechaUnionModificada: any;

  ngOnInit(): void {
    this.fechaUnionModificada = this.transformDate();
    this.getEntradas()
  }
  transformDate(){
    return this.datepipe.transform(this.fileService.getUser().fechaUnion, 'dd/MM/yyyy, h:mm a');
  }

  editarPerfil(){
    var usuario = this.fileService.getUser();
    const contrasena = (document.getElementById('contrasena') as HTMLInputElement).value;
    const correo = (document.getElementById('correo') as HTMLInputElement).value;
    const nombre = (document.getElementById('nombre') as HTMLInputElement).value;
    const apellido = (document.getElementById('apellido') as HTMLInputElement).value;
    const telefono = (document.getElementById('telefono') as HTMLInputElement).value;
    const descripcion = (document.getElementById('descripcion') as HTMLInputElement).value;
    usuario.password = (contrasena != "") ? contrasena : usuario.password;
    usuario.correo = (correo != "") ? correo : usuario.correo;
    usuario.primerNombre = (nombre != "") ? nombre : usuario.nombre;
    usuario.apellido = (apellido != "") ? apellido : usuario.apellido;
    usuario.telefono = (telefono != "") ? telefono : usuario.telefono;
    usuario.descripcion = (descripcion != "") ? descripcion : usuario.descripcion;
    this.fileService.editarPerfil(usuario).subscribe(_ => {alert("Usuario Modificado Exitosamente"); this.fileService.setUser(usuario);});
  }

  getEntradas(){
    this.fileService.getEntradas().subscribe((res:any) => {this.listaEntradas = res});
  }

}
