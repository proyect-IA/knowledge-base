﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Informacion
{
    /// <summary>
    /// Clase que representa un estado en el árbol de busqueda
    /// </summary>
    public class Nodo
    {
        /// <summary>
        /// Propiedad que inicia el estado de la unidad
        /// </summary>
        public InfoUnidad unidad  { get; set; }


        /// <summary>
        /// Propiedad que contiene la lista de hijos
        /// </summary>
        public List<Nodo> hijos    { get; set; }
    }
}
