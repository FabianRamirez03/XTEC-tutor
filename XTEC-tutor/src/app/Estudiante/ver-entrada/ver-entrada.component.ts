// noinspection TypeScriptValidateJSTypes
import {DatePipe} from '@angular/common'
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import {FileService} from "../../_service/file.service";
import {NgbModal} from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-ver-entrada',
  templateUrl: './ver-entrada.component.html',
  styleUrls: ['./ver-entrada.component.scss']
})
export class VerEntradaComponent implements OnInit {
  public id: any;
  public message: any;
  public entrada: any;
  listaComentarios: any;
  constructor(private route: ActivatedRoute, public fileService: FileService, private datepipe: DatePipe, private modal:NgbModal) { }

  ngOnInit(): void {
    this.id = this.route.snapshot.params.id;
    this.obtenerEntrada();
    this.getComentarios();
    this.fileService.agregarVista(this.id);
  }
  obtenerEntrada(){
    this.fileService.obtenerEntrada(this.id).subscribe((resp:any)=>{this.entrada = resp; console.log(resp)})
  }
  transformDate(){
     return this.datepipe.transform(this.entrada.fechaCreacion, 'dd/MM/yyyy');
  }

  download() {
    this.fileService.download(this.id).subscribe((event) => {
      this.message = 'Download success.';
      console.log(event);
      var contentDispositionHeader = event.headers.get('Content-Disposition');
      // @ts-ignore
      var result = contentDispositionHeader.split(';')[1].trim().split('=')[1];
      const blob = event.body;
      this.downloadFile(<Blob>blob, result.replace(/"/g, ''));

    });
  }

  private downloadFile(data: Blob, filename:string) {
    console.log(data);
    const downloadedFile = new Blob([data], { type: data.type});
    const a = document.createElement('a');
    a.setAttribute('style', 'display:none;');
    document.body.appendChild(a);
    a.download = filename;
    a.href = URL.createObjectURL(downloadedFile);
    a.target = '_blank';
    a.click();
    document.body.removeChild(a);
  }

  comentarEntrada(){
    const comentario = (document.getElementById('comentario') as HTMLInputElement).value;
    const nota = (document.getElementById('nota') as HTMLInputElement).value;
    if (nota != ""){
      this.fileService.comentarEntrada(comentario, nota, this.id);
      console.log(comentario);
    }
    else{
      alert("Ingrese una Puntuaci??n")
    }
  }

  // @ts-ignore
  openCentrado(contenido){
    this.modal.open(contenido,{centered: true, scrollable: true});
  }

  getComentarios(){
    this.fileService.getComentarios(this.id).subscribe((res:any) => this.listaComentarios = res);
  }

  // @ts-ignore
  formatoFecha(fecha){
    return this.datepipe.transform(fecha, 'dd/MM/yyyy-hh:mma');
  }

}
