import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule, routingComponents } from './app-routing.module';
import { AppComponent } from './app.component';

import { MatButtonModule } from '@angular/material/button';
import { MatDialogModule } from '@angular/material/dialog';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AdminNavBarComponent } from './Components/admin-nav-bar/admin-nav-bar.component';
import { FooterComponent } from './Components/footer/footer.component';
import {FormsModule} from "@angular/forms";
import { UploadComponent } from './upload/upload.component';
import { HttpClientModule } from '@angular/common/http';
import { DownloadComponent } from './download/download.component';
import { StudentNavBarComponent } from './Components/student-nav-bar/student-nav-bar.component';




@NgModule({
  declarations: [
    AppComponent,
    routingComponents,
    AdminNavBarComponent,
    FooterComponent,
    UploadComponent,
    DownloadComponent,
    StudentNavBarComponent,
  ],
    imports: [
        BrowserModule,
        AppRoutingModule,
        FormsModule,
        BrowserAnimationsModule,
        MatButtonModule,
        MatDialogModule,
        FormsModule,
        HttpClientModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
