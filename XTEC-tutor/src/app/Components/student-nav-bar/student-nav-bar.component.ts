import { Component, OnInit } from '@angular/core';
import {FileService} from "../../_service/file.service";

@Component({
  selector: 'app-student-nav-bar',
  templateUrl: './student-nav-bar.component.html',
  styleUrls: ['./student-nav-bar.component.scss']
})
export class StudentNavBarComponent implements OnInit {

  constructor(public fileService: FileService) { }

  ngOnInit(): void {
  }

}
