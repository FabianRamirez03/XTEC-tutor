import { Component, OnInit } from '@angular/core';
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';
import {FileService} from "../../_service/file.service";


@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent implements OnInit {

  constructor(private modal:NgbModal, private fileService:FileService) { }
  listaCarreras=[{carrera: 'Seleccione Carrera'}];
  listaCursos=[{curso: 'Seleccione Cursos'}];
  listaTemas=[{tema: 'Seleccione Temas'}];
  ngOnInit(): void {
    this.getCarreras()
  }

  // @ts-ignore
  openCentrado(contenido){
    this.modal.open(contenido,{centered:true});
  }

  getCarreras(){
    this.fileService.getCarreras().subscribe((resp:any) => {this.listaCarreras = resp; this.getCursos(1)})

  }

  getCursos(opcion:number){
    var id =""
    if (opcion == 1){
      id= "SelectCarrera";
    }
    else{
      id = "SelectCarreraModalTema"
    }
    this.fileService.getCursos((document.getElementById(id) as HTMLInputElement).value).
    subscribe((resp:any) => {this.listaCursos = resp})
  }

  getTemas(){
    var tema =  (document.getElementById('SelectCurso') as HTMLInputElement).value;
    if (tema == null){tema = "nulo"}
    this.fileService.getTemas(tema).
    subscribe((resp:any) => {this.listaTemas = resp})
  }

  crearCarrera(){
      const carrera = (document.getElementById('nuevaCarrera') as HTMLInputElement).value;
      this.fileService.crearCatalogo(carrera,"","");
  }

  crearCurso(){
    const carrera = (document.getElementById('SelectCarreraModalCurso') as HTMLInputElement).value;
    const curso = (document.getElementById('nuevaCurso') as HTMLInputElement).value;
    this.fileService.crearCatalogo(carrera,curso,"");
  }

  crearTema(){
    const carrera = (document.getElementById('SelectCarreraModalTema') as HTMLInputElement).value;
    const curso = (document.getElementById('SelectCursoModalTema') as HTMLInputElement).value;
    const tema = (document.getElementById('nuevoTema') as HTMLInputElement).value;
    this.fileService.crearCatalogo(carrera,curso,tema);
  }





}
