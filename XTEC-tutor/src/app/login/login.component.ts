import { Component, OnInit } from '@angular/core';
import {FileService} from "../_service/file.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  constructor(private fileService: FileService, private router: Router) { }

  ngOnInit(): void {
  }

  public iniciarSesion(){
    this.fileService.login((document.getElementById('user') as HTMLInputElement).value,
      (document.getElementById('password') as HTMLInputElement).value).then(tipo=> {
        const type:any = tipo;
        if (type == 1) {
          this.router.navigate(['/', 'admin']);
          this.fileService.setUser(this.fileService.usuario);
        } else if (type == 2) {
          this.fileService.setUser(this.fileService.usuario);
          this.router.navigate(['/', 'inicio']);
        } else {
          alert("No se ha podido reconocer la cuenta jeje salu2")
        }
      }
  )
  }

}
