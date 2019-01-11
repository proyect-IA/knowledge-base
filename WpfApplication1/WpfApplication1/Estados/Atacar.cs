using System;
using System.Collections.Generic;
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
    public class Atacar : IAccionAutonoma
    {

        private Atacar()
        {
            en_ataque = true;
            objetivo = new Point();
            disparo = new Point();
        }

        /// <summary>
        /// Propiedad que indica si es posible efectuar el ataque
        /// </summary>
        public bool en_ataque { get; set; }

        private static Atacar instancia;
        public Point disparo;
        public Point objetivo;

        public static Atacar Instancia
        {
            get
            {
                if (instancia == null)
                {
                    instancia = new Atacar();
                }

                return instancia;
            }
        }

        /// <summary>
        /// Propiedad que permite ejecutar una acción autonoma
        /// </summary>
        public Canvas ejecutarAccionAutonomo(ControlVisualSimulacion c)
        {

            if (en_ataque)
            {

                if (c != null)
                {
                    if (disparo.X != 0 && disparo.Y != 0)
                    {
                        Application.Current.Dispatcher.BeginInvoke(DispatcherPriority.Background, new Action(() => calcular(c)));
                    }
                    else
                    {
                        objetivo.X = c.enemiga.x;
                        objetivo.Y = c.enemiga.y;

                        disparo.X = c.autonoma.x;
                        disparo.Y = c.autonoma.y;
                    }
                }                
            }

            return c.canvas;
        }

        private void calcular(ControlVisualSimulacion c)
        {
            c.canvas.Children.Clear();

            if (disparo.X == objetivo.X && disparo.Y == objetivo.Y)
            {
                objetivo.X = c.enemiga.x;
                objetivo.Y = c.enemiga.y;

                disparo.X = c.autonoma.x;
                disparo.Y = c.autonoma.y;

                en_ataque = false;

                PublicadorEventoCambioEstado.obtenerInstancia().LanzarEvento(this, new EventoCambioEstado());
            }
            else
            { 
                if (disparo.X > objetivo.X)
                {
                    disparo.X -= 1;
                }
                
                if (disparo.X < objetivo.X)
                {
                    disparo.X += 1;
                }
                if (disparo.Y > objetivo.Y)
                {
                    disparo.Y -= 1;
                }
                if (disparo.Y < objetivo.Y)
                {
                    disparo.Y += 1;
                }
                c._vista.TablaUnidadAutonoma.ItemsSource = new List<Unidad>() { c.autonoma };
                c._vista.TablaUnidadEnemiga.ItemsSource  = new List<Unidad>() { c.enemiga };

                Canvas.SetLeft(c.ia, c.autonoma.x);
                Canvas.SetTop(c.ia, c.autonoma.y);

                Canvas.SetLeft(c.visiIA, c.autonoma.x - 30);
                Canvas.SetTop(c.visiIA, c.autonoma.y - 30);

                Canvas.SetLeft(c.ene, c.enemiga.x);
                Canvas.SetTop(c.ene, c.enemiga.y);

                Canvas.SetLeft(c.visiEn, c.enemiga.x - 30);
                Canvas.SetTop(c.visiEn, c.enemiga.y - 30);

                Canvas.SetLeft(c.bala, disparo.X);
                Canvas.SetTop(c.bala, disparo.Y);

                c.canvas.Children.Add(c.ia);
                c.canvas.Children.Add(c.visiIA);
                c.canvas.Children.Add(c.ene);
                c.canvas.Children.Add(c.visiEn);
                c.canvas.Children.Add(c.bala);

                if (ServicioColiciones.verificarColicion(new Unidad() { x = (int)disparo.X, y = (int)disparo.Y}, c.enemiga, 15))
                {
                    c.enemiga.nivel_operatividad -= 1;
                }
            }

            
        }

        /// <summary>
        /// Método que permite restablecer el estado actual desplazamiento
        /// </summary>
        public void restablecerAccion()
        {
            
        }
    }
}
