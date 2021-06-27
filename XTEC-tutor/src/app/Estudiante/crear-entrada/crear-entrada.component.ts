import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import { EditorModule } from '@tinymce/tinymce-angular';
import { FormControl, FormGroup, Validators, FormBuilder } from '@angular/forms'
import {HttpEventType} from "@angular/common/http";
import {FileService} from "../../_service/file.service";
import {ActivatedRoute} from "@angular/router";
@Component({
  selector: 'app-crear-entrada',
  templateUrl: './crear-entrada.component.html',
  styleUrls: ['./crear-entrada.component.scss']
})
export class CrearEntradaComponent implements OnInit {
  articulo = {
    Titulo: "",
    message: ` <p>Inicio del Artículo</p>`
  };
  entrada = new FormGroup({});

  public message: string = "";
  public progress: number = 0;
  @Output() public onUploadFinished = new EventEmitter();
  public file:any;
  public idEntrada:any;
  public nuevo = true;
  listaCarreras=[{carrera: 'Seleccione Carrera'}];
  listaCursos=[{curso: 'Seleccione Cursos'}];
  listaTemas=[{tema: 'Seleccione Temas'}];
  entradaAnterior={cuerpoArticulo: "Entrada nueva", descripcion: "Descripción", titulo: "Título"};

  constructor(private route: ActivatedRoute, private fb: FormBuilder, private fileService: FileService) { }
  ngOnInit(): void {
    this.getCarreras();
    this.idEntrada = this.route.snapshot.params.id;
    if (this.idEntrada != 0){
      this.nuevo = false;
      this.obtenerEntrada();
      this.articulo.message = this.entradaAnterior.cuerpoArticulo;
    }
    this.setupForm();
  }
  setupForm() {
    if(this.nuevo){
      this.entrada = this.fb.group({
        Titulo: [""],
        message: [this.articulo.message]
      });
    }
    else{
      this.entrada = this.fb.group({
        Titulo: [""],
        message: [this.entradaAnterior.cuerpoArticulo]
      });
    }

  }

  submit(){
    console.log(this.entrada.value.message);
  }
  obtenerEntrada(){
    this.fileService.obtenerEntrada(this.idEntrada).subscribe((resp:any)=>{this.entradaAnterior = resp; console.log(resp)})
  }
  public subirArchivo(files:any){
    if (files.length === 0){
      return;
    }
    let fileToUpload = <File>files[0];
    this.file = fileToUpload;
    this.message = fileToUpload.name;
  }

  public uploadFile(){
    const formData = new FormData();
    let descripcion = (document.getElementById('descripcion') as HTMLInputElement).value;
    let titulo = (document.getElementById('titulo') as HTMLInputElement).value;
    let cuerpo = this.entrada.value.message
    descripcion = (descripcion != "") ? descripcion : this.entradaAnterior.descripcion;
    titulo = (titulo != "") ? titulo : this.entradaAnterior.titulo;
    cuerpo = (cuerpo != "Entrada nueva") ? cuerpo : this.entradaAnterior.cuerpoArticulo;


    formData.append('cuerpoArticulo',cuerpo);
    formData.append('titulo', titulo);
    formData.append('descripcion', descripcion);
    formData.append('carrera', (document.getElementById('SelectCarrera') as HTMLInputElement).value);
    formData.append('curso', (document.getElementById('SelectCurso') as HTMLInputElement).value);
    formData.append('tema', (document.getElementById('ListaTemas') as HTMLInputElement).value);
    formData.append('idEntrada', this.idEntrada);
    formData.append('carnet', this.fileService.getUser().carnet);
    formData.append('visible', '1');
    console.log(formData);
    console.log(this.entrada.value.message);
    if (this.file !=  undefined){
      let fileToUpload = this.file;
      console.log(fileToUpload);
      formData.append('file', fileToUpload, fileToUpload.name);
    }
    this.fileService.upload(formData, this.nuevo)
      .subscribe(event => {
        console.log(event);
        if (event.type === HttpEventType.UploadProgress){
          // @ts-ignore
          this.progress =  Math.round(100 * event.loaded/ event.total);
        }
        else if(event.type === HttpEventType.Response){
          this.message = "Carga Completada.";
          this.onUploadFinished.emit(event.body);
          alert("Artículo Publicado Exitosamente");
        }

      });
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
    subscribe((resp:any) => {this.listaCursos = resp})
  }

  getTemas(){
    var tema =  (document.getElementById('SelectCurso') as HTMLInputElement).value;
    if (tema == null){tema = "nulo"}
    this.fileService.getTemas(tema).
    subscribe((resp:any) => {this.listaTemas = resp})
  }
}
