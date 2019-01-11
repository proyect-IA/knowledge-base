using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Threading;
using WpfApplication1.Eventos;
using WpfApplication1.Informacion;
using WpfApplication1.Interfaces;
using WpfApplication1.Servicios;

namespace WpfApplication1.Estados
{
    public class Retirada : IAccionAutonoma
    {

        /// <summary>
        /// Propiedad que indica si el 
        /// </summary>
        public bool en_ejecucion { get; set; }
        public System.Windows.Point unidad_IA   { get; set; }

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        private Retirada()
        {
            en_ejecucion = true;
        }

        private static Retirada instancia;

        public static Retirada Instancia
        {
            get
            {
                if (instancia == null)
                {
                    instancia = new Retirada();
                }

                return instancia;
            }
        }

        /// <summary>
        /// Propiedad que permite ejecutar una acción autonoma
        /// </summary>
        public Canvas ejecutarAccionAutonomo(ControlVisualSimulacion c)
        {
            if (unidad_IA.X == 0 && unidad_IA.Y == 0)
            {
                unidad_IA = generarCoordenada(c);
                System.Windows.Point punto = generarCoordenada(c);
                c.enemiga.x = (int)punto.X;
                c.enemiga.x = (int)punto.Y;
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
                unidad_IA = generarCoordenada(c);
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
            else if (c.autonoma.x > unidad_IA.X)
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
                en_ejecucion = false;
                unidad_IA = generarCoordenada(c);
                PublicadorEventoCambioEstado.obtenerInstancia().LanzarEvento(this, new EventoCambioEstado());
            }

            c._vista.TablaUnidadAutonoma.ItemsSource = new List<Unidad>() { c.autonoma };
            c._vista.TablaUnidadEnemiga.ItemsSource = new List<Unidad>() { c.enemiga };

            Canvas.SetLeft(c.ia, c.autonoma.x);
            Canvas.SetTop(c.ia, c.autonoma.y);

            Canvas.SetLeft(c.visiIA, c.autonoma.x - 30);
            Canvas.SetTop(c.visiIA, c.autonoma.y - 30);

            Canvas.SetLeft(c.ene, c.enemiga.x);
            Canvas.SetTop(c.ene, c.enemiga.y);

            Canvas.SetLeft(c.visiEn, c.enemiga.x - 30);
            Canvas.SetTop(c.visiEn, c.enemiga.y - 30);

            c.canvas.Children.Add(c.ia);
            c.canvas.Children.Add(c.visiIA);
            c.canvas.Children.Add(c.ene);
            c.canvas.Children.Add(c.visiEn);

            if (ServicioColiciones.verificarColicion(c.autonoma, c.enemiga, 90))
            {
                //Se detiene el estado del desplazamiento
                en_ejecucion = false;

                //se lanza el evento de cambio de estado
                PublicadorEventoCambioEstado.obtenerInstancia().LanzarEvento(this, new EventoCambioEstado());
            }
        }

        /// <summary>
        /// Método que permite configurar un punto distante al enemigo
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        public System.Windows.Point generarCoordenada(ControlVisualSimulacion c)
        {
            System.Windows.Point punto   = new System.Windows.Point();
            int distancia = ServicioColiciones.obtenerDistanciaEntrePuntos(c.autonoma, c.enemiga);

            if (c.enemiga.x > c.autonoma.x && c.enemiga.y < c.autonoma.y)
            {
                punto.X = c.autonoma.x - distancia;
                punto.Y = c.autonoma.y + distancia;
            }
            else if (c.enemiga.x < c.autonoma.x && c.enemiga.y < c.autonoma.y)
            {
                punto.X = c.autonoma.x + distancia;
                punto.Y = c.autonoma.y + distancia;
            }
            else if (c.enemiga.x > c.autonoma.x && c.enemiga.y > c.autonoma.y)
            {
                punto.X = c.autonoma.x - distancia;
                punto.Y = c.autonoma.y - distancia;
            }
            else if (c.enemiga.x < c.autonoma.x && c.enemiga.y > c.autonoma.y)
            {
                punto.X = c.autonoma.x + distancia;
                punto.Y = c.autonoma.y - distancia;
            }

            return punto;
        }

        /// <summary>
        /// Método que permite restablecer el estado actual desplazamiento
        /// </summary>
        public void restablecerAccion()
        {
        }
    }
}
