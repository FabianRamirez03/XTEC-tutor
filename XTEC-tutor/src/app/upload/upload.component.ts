import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {HttpClient, HttpEventType} from "@angular/common/http";
import {FileService} from "../_service/file.service";

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.scss']
})
export class UploadComponent implements OnInit {
  public message: string = "";
  public progress: number = 0;
  @Output() public onUploadFinished = new EventEmitter();

  constructor(private fileService: FileService) { }

  ngOnInit(): void {
  }

  public uploadFile = (files:any) =>{
    if (files.length === 0){
      return;
    }
    let fileToUpload = <File>files[0];
    const formData = new FormData();
    formData.append('file', fileToUpload, fileToUpload.name);


    this.fileService.upload(formData, true)
      .subscribe(event => {
        if (event.type === HttpEventType.UploadProgress){
          // @ts-ignore
          this.progress =  Math.round(100 * event.loaded/ event.total);
        }
        else if(event.type === HttpEventType.Response){
            this.message = "Carga Completada.";
            this.onUploadFinished.emit(event.body);
        }
      } );
  }

}
