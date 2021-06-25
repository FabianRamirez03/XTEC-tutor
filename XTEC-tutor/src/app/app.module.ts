import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule, routingComponents } from './app-routing.module';
import { AppComponent } from './app.component';

import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule } from '@angular/material/dialog';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { DatePipe } from '@angular/common';

import { AdminNavBarComponent } from './Components/admin-nav-bar/admin-nav-bar.component';
import { FooterComponent } from './Components/footer/footer.component';
import {FormsModule, ReactiveFormsModule} from "@angular/forms";
import { UploadComponent } from './upload/upload.component';
import { HttpClientModule } from '@angular/common/http';
import { DownloadComponent } from './download/download.component';
import { StudentNavBarComponent } from './Components/student-nav-bar/student-nav-bar.component';
import { CrearEntradaComponent } from './Estudiante/crear-entrada/crear-entrada.component';
import {EditorModule} from "@tinymce/tinymce-angular";
import { BusquedaComponent } from './Estudiante/busqueda/busqueda.component';




@NgModule({
  declarations: [
    AppComponent,
    routingComponents,
    AdminNavBarComponent,
    FooterComponent,
    UploadComponent,
    DownloadComponent,
    StudentNavBarComponent,
    CrearEntradaComponent,
    BusquedaComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    BrowserAnimationsModule,
    MatButtonModule,
    MatDialogModule,
    FormsModule,
    HttpClientModule,
    EditorModule,
    ReactiveFormsModule
  ],
  providers: [DatePipe],

  bootstrap: [AppComponent]
})
export class AppModule { }
