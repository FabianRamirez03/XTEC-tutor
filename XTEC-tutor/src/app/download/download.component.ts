import {Component, Input, OnInit} from '@angular/core';
import {FileService} from "../_service/file.service";
import {HttpEventType, HttpResponse} from "@angular/common/http";

@Component({
  selector: 'app-download',
  templateUrl: './download.component.html',
  styleUrls: ['./download.component.scss']
})
export class DownloadComponent implements OnInit {

  constructor(private fileService: FileService) {}
  message: string = "";
  progress: number = 0;
  @Input() public fileUrl: string = "";
  ngOnInit(): void {}
  download() {
    this.fileService.download(24).subscribe((event) => {
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

}
