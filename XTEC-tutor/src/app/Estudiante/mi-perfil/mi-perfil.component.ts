import {Component, OnInit} from '@angular/core';
import {FileService} from "../../_service/file.service";
import {DatePipe} from '@angular/common'
import { Router, ActivatedRoute, ParamMap } from '@angular/router';

@Component({
  selector: 'app-mi-perfil',
  templateUrl: './mi-perfil.component.html',
  styleUrls: ['./mi-perfil.component.scss']
})
export class MiPerfilComponent implements OnInit {

  constructor(public fileService: FileService, public datepipe: DatePipe, private route: ActivatedRoute) { }
  listaEntradas:any;
  fechaUnionModificada: any;
  fotoPredeterminada = 'https://bootdey.com/img/Content/avatar/avatar6.png';
  foto: any;

  ngOnInit(): void {
    this.checkFoto()
    this.fechaUnionModificada = this.transformDate();
    this.getEntradas()
  }
  transformDate(){
    return this.datepipe.transform(this.fileService.getUser().fechaUnion, 'dd/MM/yyyy, h:mm a');
  }
  checkFoto(){
    if (this.fileService.getUser().fotografia == ""){
      this.foto = this.fotoPredeterminada;
    }else{
      this.foto = this.fileService.getUser().fotografia
    }
  }

  editarPerfil(){
    var usuario = this.fileService.getUser();
    const contrasena = (document.getElementById('contrasena') as HTMLInputElement).value;
    const correo = (document.getElementById('correo') as HTMLInputElement).value;
    const nombre = (document.getElementById('nombre') as HTMLInputElement).value;
    const apellido = (document.getElementById('apellido') as HTMLInputElement).value;
    const telefono = (document.getElementById('telefono') as HTMLInputElement).value;
    const descripcion = (document.getElementById('descripcion') as HTMLInputElement).value;
    const fotografia = this.foto
    usuario.password = (contrasena != "") ? contrasena : usuario.password;
    usuario.correo = (correo != "") ? correo : usuario.correo;
    usuario.primerNombre = (nombre != "") ? nombre : usuario.nombre;
    usuario.apellido = (apellido != "") ? apellido : usuario.apellido;
    usuario.telefono = (telefono != "") ? telefono : usuario.telefono;
    usuario.descripcion = (descripcion != "") ? descripcion : usuario.descripcion;
    usuario.fotografia = (fotografia != "") ? fotografia : usuario.fotografia;
    this.fileService.editarPerfil(usuario).subscribe(_ => {alert("Usuario Modificado Exitosamente"); this.fileService.setUser(usuario);});
  }

  getEntradas(){
    this.fileService.getEntradas().subscribe((res:any) => {this.listaEntradas = res});
  }

  // @ts-ignore
  setByteArray(files): void {
    const reader = new FileReader();
    // this.profile.image = files;
    reader.readAsDataURL(files[0]);
    reader.onload = e => {
      const bytes = reader.result;
      // @ts-ignore
      this.foto = bytes.toString();
      console.log(this.foto)
      this.editarPerfil()
    };
  }
  openFile(){
    // @ts-ignore
    document.querySelector('input').click()
  }

  // @ts-ignore
  cambiarVisibilidad(idEntrada){
    this.fileService.cambiarVisibilidad(idEntrada).subscribe((res:any) => {
      console.log('Entrada modificada');
      this.ngOnInit()})
  }

}
