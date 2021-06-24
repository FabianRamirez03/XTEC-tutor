import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { MainComponent } from './Administrador/main/main.component';
import { DashBoardComponent } from './Estudiante/dash-board/dash-board.component';
import { MiPerfilComponent } from './Estudiante/mi-perfil/mi-perfil.component';


const routes: Routes = [
  {path: 'login', component: LoginComponent},
  {path: '', redirectTo: '/login', pathMatch: 'full' },
  {path: 'admin', component: MainComponent},
  {path: 'inicio', component: DashBoardComponent},
  {path: 'perfil', component: MiPerfilComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
export const routingComponents = [LoginComponent, MainComponent, DashBoardComponent, MiPerfilComponent]
