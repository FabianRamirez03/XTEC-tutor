import { Component } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {FileService} from "./_service/file.service";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'XTEC-tutor';
  public photos: string[] = [];
constructor(private http: HttpClient, private fileService: FileService) {}

  ngOnInit() {
    this.getPhotos();
  }
  private getPhotos = () => {
    // @ts-ignore
    this.fileService.getPhotos().subscribe(data => this.photos = data['photos']);
  }
  public returnToCreate = () => {
    this.getPhotos();
  }

  public createImgPath = (serverPath: string) => {
    return `https://localhost:5001/${serverPath}`;
  }

}
