import { Injectable } from '@angular/core';
import {HttpClient, HttpResponse} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class FileService {
  usuario: any = {};
  constructor(private http: HttpClient) { }
  public  url = "https://xtectutorapi.azurewebsites.net/api";
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
  public login(carnet:string, password:string):Promise<Number>{
      return this.http.post(`${this.url}/Users/login`, {
        carnet: carnet,
        password: password
      }).toPromise().then(
        (resp: any) =>{
          this.usuario.tipoUsuario = resp.tipoUsuario;
          this.usuario.carnet = carnet;
          if(resp.tipoUsuario == 2 ){
              this.usuario.primerNombre = resp.primerNombre;
              this.usuario.apellido = resp.apellido;
              this.usuario.descripcion = resp.descripcion;
              this.usuario.sede = resp.sede;
              this.usuario.telefono = resp.telefono;
              this.usuario.fechaUnion = resp.fechaUnion;
              this.usuario.fotografia = resp.fotografia;
              this.usuario.correo = resp.correo;
              this.usuario.password = password;
          }
          console.log(this.usuario);
          return this.usuario.tipoUsuario;
        })
  }

  public crearCatalogo(carrera:string, curso:string, tema:string){
    return this.http.post(`${this.url}/Catalogos/crearCatalogo`,
      {
            usuarioAdmin: this.getUser().carnet,
            carrera: carrera,
            curso: curso,
            tema: tema
    }).subscribe(_=>{alert(`Catalogo de ${carrera} creada por ${this.getUser().carnet.toString()}`)});
  }

  public getCarreras(){
    return this.http.get(`${this.url}/Catalogos/getCarreras`)
  }

  public getCursos(carrera:string){
    return this.http.get(`${this.url}/Catalogos/getCursos?carrera=${carrera}`)
  }

  public getTemas(curso:string){
    return this.http.get(`${this.url}/Catalogos/getTemas?curso=${curso}`)
  }

  public getUser(){
    const data = window.localStorage.getItem("usuario");
    return JSON.parse(<string>data);
  }
  public setUser(user:any){
    window.localStorage.setItem("usuario", JSON.stringify(user));
  }



}
