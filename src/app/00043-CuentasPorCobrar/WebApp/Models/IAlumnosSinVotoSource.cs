﻿using Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Models
{
    public interface IAlumnosSinVotoSource
    {
        List<AlumnoMultaNoVotarEntity> GetList(string filePath);
    }
}