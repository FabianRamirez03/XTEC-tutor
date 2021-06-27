import { Injectable } from '@angular/core';
import {HttpClient, HttpResponse} from "@angular/common/http";

@Injectable({
  providedIn: 'root'
})
export class FileService {
  usuario: any = {};
  constructor(private http: HttpClient) { }
  public  url = "https://xtectutorapi.azurewebsites.net/api";
  // public  url = "https://localhost:5001/api";

  public upload(formData: FormData, nuevo: boolean) {
    if (nuevo){
      return this.http.post(`${this.url}/file/upload`, formData, {
        reportProgress: true,
        observe: 'events',
      });
    }
    else{
      return this.http.post(`${this.url}/file/editarEntrada`, formData, {
        reportProgress: true,
        observe: 'events',
      });
    }
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
    }).subscribe(_=>{alert(`Catalogo de ${carrera} creado exitosamente`)});
  }

  public comentarEntrada(comentario:string, nota:string, idEntrada:string){
    this.http.post(`${this.url}/Review/comentarEntrada`,
      {
        carnet: this.getUser().carnet,
        idEntrada: idEntrada,
        comentario: comentario,
      }).subscribe(_=>{alert(`Comentario Enviado Correctamente`)});
    this.http.post(`${this.url}/Review/puntuarEntrada`,
      {
        carnet: this.getUser().carnet,
        idEntrada: idEntrada,
        nota: Number(nota),
      }).subscribe(_=>console.log(`nota publicada ${Number(nota)}`))

  }

  public editarPerfil(usuario:any){
    console.log(usuario);
    return this.http.post(`${this.url}/Users/editarPerfil`,usuario)
  }

  public getCarreras(){
    return this.http.get(`${this.url}/Catalogos/getCarreras`)
  }

  public getEntradas(){
    return this.http.get(`${this.url}/Entrada/verEntradas?carnet=${this.getUser().carnet}`)
  }

  public obtenerEntrada(id:any){
    return this.http.get(`${this.url}/Entrada/obtenerEntrada?idEntrada=${id}`)
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

  public cambiarVisibilidad(id:string){
    return this.http.get(`${this.url}/Entrada/cambiarVisibilidad?idEntrada=${id}`)
  }

  public getComentarios(id:string){
    return this.http.get<any>(`${this.url}/Review/getReviews?idEntrada=${id}`)
  }

  public agregarVista(id:string){
    return this.http.get<any>(`${this.url}/Entrada/agregarVista?idEntrada=${id}`).subscribe(_=>{})
  }



}
