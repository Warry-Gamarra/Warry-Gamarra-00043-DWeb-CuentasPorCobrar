﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.ViewModels
{
    public class SelectViewModel
    {
        public string Value { get; set; }
        public string TextDisplay { get; set; }
        public string NameGroup { get; set; }
    }

    public class SelectGroupViewModel
    {
        public string NameGroup { get; set; }
        public IList<SelectViewModel> ItemsGroup { get; set; }
    }

}