// noinspection TypeScriptValidateJSTypes
import {DatePipe} from '@angular/common'
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import {FileService} from "../../_service/file.service";

@Component({
  selector: 'app-ver-entrada',
  templateUrl: './ver-entrada.component.html',
  styleUrls: ['./ver-entrada.component.scss']
})
export class VerEntradaComponent implements OnInit {
  public id: any;
  public entrada: any;
  public fechaCorregida: any;
  constructor(private route: ActivatedRoute, private fileService: FileService, private datepipe: DatePipe,) { }

  ngOnInit(): void {
    this.id = this.route.snapshot.params.id;
    this.obtenerEntrada()
  }
  obtenerEntrada(){
    this.fileService.obtenerEntrada(this.id).subscribe((resp:any)=>{this.entrada = resp})
  }
  transformDate(){
     return this.datepipe.transform(this.entrada.fechaCreacion, 'dd/MM/yyyy');
  }
}
