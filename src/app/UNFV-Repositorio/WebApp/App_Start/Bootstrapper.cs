﻿using Autofac;
using Autofac.Integration.Mvc;
using Domain;
using Domain.Services;
using Domain.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;

namespace WebApp.App_Start
{
    public class Bootstrapper
    {
        public static void Run()
        {
            SetAutofacContainer();
        }

        private static void SetAutofacContainer()
        {
            var builder = new ContainerBuilder();

            RegisterServices(builder);

            IContainer container = builder.Build();

            DependencyResolver.SetResolver(new AutofacDependencyResolver(container));
        }

        private static void RegisterServices(ContainerBuilder builder)
        {
            builder.RegisterControllers(Assembly.GetExecutingAssembly());

            builder.RegisterType<AlumnoService>().As<IAlumnoService>().InstancePerRequest();

            builder.RegisterType<ProgramaUnfvService>().As<IProgramaUnfvService>().InstancePerRequest();

            builder.RegisterModule<CoreLibModule>();
        }
    }
}