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

  fechaUnionModificada: any;

  ngOnInit(): void {
    this.fechaUnionModificada = this.transformDate()
  }
  transformDate(){
    return this.datepipe.transform(this.fileService.getUser().fechaUnion, 'dd/MM/yyyy, h:mm a');
  }

}
