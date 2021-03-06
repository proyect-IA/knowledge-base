﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Threading;
using WpfApplication1.Eventos;
using WpfApplication1.Informacion;
using WpfApplication1.Interfaces;
using WpfApplication1.Servicios;

namespace WpfApplication1.Estados
{

    public class Desplazar : IAccionAutonoma
    {
       

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        private Desplazar()
        {
            en_ejecucion = true;
        }

        private static Desplazar instancia;

        public static Desplazar Instancia
        {
            get
            {
                if(instancia == null)
                {
                    instancia = new Desplazar();
                }

                return instancia;
            }
        }            
        

        /// <summary>
        /// Propiedad que indica si esta en ejecución el estado
        /// </summary>
        public bool en_ejecucion { get; set; }

        /// <summary>
        /// Propiedad que contiene el punto de ubicación para la unidad inteligente
        /// </summary>
        public Point unidad_IA; 

        /// <summary>
        /// Propiedad que permite ejecutar una acción autonoma
        /// </summary>
        public Canvas ejecutarAccionAutonomo(ControlVisualSimulacion c)
        {
            if (unidad_IA.X == 0 && unidad_IA.Y == 0)
            {
                unidad_IA    = generarCoordenada(c.canvas);
                Point punto  = generarCoordenada(c.canvas);
                c.enemiga.x  = (int)punto.X;
                c.enemiga.x  = (int)punto.Y;
            }

            if (en_ejecucion)
            {
                if (c != null)
                {
                    Application.Current.Dispatcher.BeginInvoke(DispatcherPriority.Background, new Action(() => calcular(c)));
                }
            }
            else
            {
                //manda llamar al método que genera la coordenada para la unidad de IA
                unidad_IA = generarCoordenada(c.canvas);
            }

            return c.canvas;
        }

        public void calcular(ControlVisualSimulacion c)
        {
            c.canvas.Children.Clear();

            if (c.autonoma.x < unidad_IA.X)
            {
                c.autonoma.x += 1;
            }
            else if(c.autonoma.x > unidad_IA.X)
            {
                c.autonoma.x -= 1;
            }

            if (c.autonoma.y < unidad_IA.Y)
            {
                c.autonoma.y += 1;
            }
            else if (c.autonoma.y > unidad_IA.Y)
            {
                c.autonoma.y -= 1;
            }

            if (unidad_IA.X == c.autonoma.x && unidad_IA.Y == c.autonoma.y)
            {
                unidad_IA = generarCoordenada(c.canvas);
            }

            c._vista.TablaUnidadAutonoma.ItemsSource = new List<Unidad>() { c.autonoma };
            c._vista.TablaUnidadEnemiga.ItemsSource  = new List<Unidad>() { c.enemiga };

            Canvas.SetLeft(c.ia, c.autonoma.x);
            Canvas.SetTop(c.ia, c.autonoma.y);

            Canvas.SetLeft(c.visiIA, c.autonoma.x-30);
            Canvas.SetTop(c.visiIA, c.autonoma.y-30);

            Canvas.SetLeft(c.ene, c.enemiga.x);
            Canvas.SetTop(c.ene, c.enemiga.y);

            Canvas.SetLeft(c.visiEn, c.enemiga.x - 30);
            Canvas.SetTop(c.visiEn, c.enemiga.y - 30);

            c.canvas.Children.Add(c.ia);
            c.canvas.Children.Add(c.visiIA);
            c.canvas.Children.Add(c.ene);
            c.canvas.Children.Add(c.visiEn);

            if (ServicioColiciones.verificarColicion(c.autonoma, c.enemiga,90))
            {
                //Se detiene el estado del desplazamiento
                en_ejecucion = false;

                //se lanza el evento de cambio de estado
                PublicadorEventoCambioEstado.obtenerInstancia().LanzarEvento(this, new EventoCambioEstado());
            }
        }

        /// <summary>
        /// Método que genera una coordenada aleatoria
        /// </summary>
        /// <returns></returns>
        public Point generarCoordenada(Canvas canvas)
        {
            double y = canvas.ActualHeight;
            double x = canvas.ActualWidth;

            Random rn = new Random();
            float xx = rn.Next(1, (int)x);
            float yy = rn.Next(1, (int)y);

            Point punto = new Point();
            punto.X = xx;
            punto.Y = yy;

            return punto;
        }

        /// <summary>
        /// Método que permite restablecer el estado actual desplazamiento
        /// </summary>
        public void restablecerAccion()
        {
            en_ejecucion = true;
        }
    }
}
