import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class FileService {

  constructor(private http: HttpClient) { }
  public  url = "https://localhost:5001/api"
  public upload(formData: FormData) {
    return this.http.post(`${this.url}/file/upload`, formData, {
      reportProgress: true,
      observe: 'events',
    });
  }
  public download(idFile: number) {
    return this.http.get(`${this.url}/file/download?idFile=${idFile}`, {
      reportProgress: true,
      responseType: 'blob' as 'json',
      observe: 'response'
    });
  }
  public getPhotos() {
    return this.http.get(`${this.url}/file/getPhotos`);
  }

}
