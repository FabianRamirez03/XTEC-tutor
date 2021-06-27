import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators, FormBuilder } from '@angular/forms'
import {HttpEventType} from "@angular/common/http";
import {FileService} from "../../_service/file.service";
import {DatePipe} from "@angular/common";

@Component({
  selector: 'app-busqueda',
  templateUrl: './busqueda.component.html',
  styleUrls: ['./busqueda.component.scss']
})
export class BusquedaComponent implements OnInit {

  constructor(public fileService: FileService, public datepipe: DatePipe) { }
  listaEntradas:any;
  listaCarreras=[{carrera: 'Seleccione Carrera'}];
  listaCursos=[{curso: 'Seleccione Cursos'}];
  listaTemas=[{tema: 'Seleccione Temas'}];

  ngOnInit(): void {
    this.getCarreras();
  }
  transformDate(){
    return this.datepipe.transform(this.fileService.getUser().fechaUnion, 'dd/MM/yyyy, h:mm a');
  }

  buscarPerfil(){
    //ayuda de wajo
    this.fileService.getEntradas().subscribe((res:any) => {this.listaEntradas = res});
  }

  getEntradas(){
    let carrera = (document.getElementById('SelectCarrera') as HTMLInputElement).value;
    let curso = (document.getElementById('SelectCurso') as HTMLInputElement).value;
    let tema = (document.getElementById('ListaTemas') as HTMLInputElement).value;
    let tipo = (document.getElementById('inlineRadio2') as HTMLInputElement).checked;
    let json = {carrera: carrera, curso: curso, tema:tema, tipo: tipo};
    this.fileService.buscarEntradas(json).subscribe((res:any) => {this.listaEntradas = res; console.log(res)});
  }
  getCarreras(){
    this.fileService.getCarreras().subscribe((resp:any) => {this.listaCarreras = resp; this.getCursos(1)})

  }

  getCursos(opcion:number){
    var id ="";
    if (opcion == 1){
      id= "SelectCarrera";
    }
    else{
      id = "SelectCarreraModalTema"
    }
    this.fileService.getCursos((document.getElementById(id) as HTMLInputElement).value).
    subscribe((resp:any) => { this.listaCursos = resp; this.listaCursos.push({curso: ""}); this.listaCursos.reverse()})
  }

  getTemas(){
    var tema =  (document.getElementById('SelectCurso') as HTMLInputElement).value;
    if (tema == null){tema = "nulo"}
    this.fileService.getTemas(tema).
    subscribe((resp:any) => {this.listaTemas = resp ; this.listaTemas.push({tema: ""}); this.listaTemas.reverse()})
  }

  formatoFecha(fecha:any){
    return this.datepipe.transform(fecha, 'dd/MM/yyyy');
  }

}
