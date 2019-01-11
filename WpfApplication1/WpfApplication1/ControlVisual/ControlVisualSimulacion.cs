using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Threading;
using WpfApplication1.Estados;
using WpfApplication1.Eventos;
using WpfApplication1.Informacion;
using WpfApplication1.Servicios;

namespace WpfApplication1
{
    public class ControlVisualSimulacion
    {

        /// <summary>
        /// Propiedad que representa el lienzo
        /// </summary>
        public Canvas canvas                      { get; set; }
        public BackgroundWorker backgroundWorker1 { get; set; }
        public Unidad autonoma                    { get; set; }
        public Unidad enemiga                     { get; set; }
        public Ellipse ia                         { get; set; }
        public Ellipse visiIA                     { get; set; }
        public Ellipse ene                        { get; set; }
        public Ellipse visiEn                     { get; set; }

        public Ellipse bala { get; set; }

        /// <summary>
        /// Propiedad que es la vista principal de la aplicación
        /// </summary>
        public MainWindow _vista                  { get; set; }

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        public ControlVisualSimulacion(MainWindow _vista)
        {
            this.canvas = _vista.lienzo;
            this._vista = _vista;

            ia = new Ellipse();
            ia.Stroke = new SolidColorBrush(Colors.Blue);
            ia.Fill = new SolidColorBrush(Colors.Blue);
            ia.Width = 30;
            ia.Height = 30;

            visiIA = new Ellipse();
            visiIA.Stroke = new SolidColorBrush(Colors.Black);
            visiIA.Width = 90;
            visiIA.Height = 90;

            ene = new Ellipse();
            ene.Stroke = new SolidColorBrush(Colors.Red);
            ene.Fill = new SolidColorBrush(Colors.Red);
            ene.Width = 30;
            ene.Height = 30;

            visiEn = new Ellipse();
            visiEn.Stroke = new SolidColorBrush(Colors.Black);
            visiEn.Width = 90;
            visiEn.Height = 90;

            bala = new Ellipse();
            bala.Stroke = new SolidColorBrush(Colors.Black);
            bala.Fill = new SolidColorBrush(Colors.Black);
            bala.Width = 5;
            bala.Height = 5;

            
            autonoma = new Unidad();
            autonoma.nivel_operatividad = 100;
            enemiga = new Unidad();
            enemiga.nivel_operatividad = 100;
            autonoma.estadoActual = Accion.MOVERCE; //inicia con el desplazamiento como primer estado actual
            enemiga.estadoActual  = Accion.MOVERCE; //inicia con el desplazamiento como primer estado actual            

            PublicadorEventoCambioEstado.obtenerInstancia().eventoCambio += ControlVisualSimulacion_eventoCambio;
            
            
        }

        /// <summary>
        /// Método que atiene el evento de coliciones
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void ControlVisualSimulacion_eventoCambio(object sender, EventoCambioEstado e)
        {
            if(autonoma.estadoActual == Accion.MOVERCE)
            {
                Atacar.Instancia.en_ataque = true;
                Atacar.Instancia.disparo.X = autonoma.x;
                Atacar.Instancia.disparo.Y = autonoma.y;
                Atacar.Instancia.objetivo.X = enemiga.x;
                Atacar.Instancia.objetivo.Y = enemiga.y;
                autonoma.estadoActual = Accion.ATACAR_DIRECTO;                
            }
            else
            {
                autonoma.estadoActual = Accion.MOVERCE;
                Desplazar.Instancia.en_ejecucion = true;
            }
        }

        public void generarPosicionesIniciales()
        {
            if (Desplazar.Instancia.unidad_IA.X == 0 && Desplazar.Instancia.unidad_IA.Y == 0)
            {
                Desplazar.Instancia.unidad_IA = Desplazar.Instancia.generarCoordenada(canvas);
                System.Windows.Point punto = Desplazar.Instancia.generarCoordenada(canvas);
                enemiga.x = (int)punto.X;
                enemiga.x = (int)punto.Y;
                autonoma.x = (int)Desplazar.Instancia.unidad_IA.X;
                autonoma.y = (int)Desplazar.Instancia.unidad_IA.Y;

                Canvas.SetLeft(ia, autonoma.x);
                Canvas.SetTop(ia, autonoma.y);

                Canvas.SetLeft(visiIA, autonoma.x - 30);
                Canvas.SetTop(visiIA, autonoma.y - 30);

                Canvas.SetLeft(ene, enemiga.x);
                Canvas.SetTop(ene, enemiga.y);

                Canvas.SetLeft(visiEn, enemiga.x - 30);
                Canvas.SetTop(visiEn, enemiga.y - 30);

                canvas.Children.Add(ia);
                canvas.Children.Add(visiIA);
                canvas.Children.Add(ene);
                canvas.Children.Add(visiEn); 
            }
        }



        public void iniciarSimulacion()
        {
            backgroundWorker1 = new BackgroundWorker();            
            InitializeBackgroundWorker();
            backgroundWorker1.RunWorkerAsync(canvas);
            generarPosicionesIniciales();
        }
        
        private void InitializeBackgroundWorker()
        {
            backgroundWorker1.DoWork             += new DoWorkEventHandler(backgroundWorker1_DoWork);
            backgroundWorker1.RunWorkerCompleted += new RunWorkerCompletedEventHandler(backgroundWorker1_RunWorkerCompleted);
            backgroundWorker1.ProgressChanged    += new ProgressChangedEventHandler(backgroundWorker1_ProgressChanged);
        }
        
        private void backgroundWorker1_DoWork(object sender,DoWorkEventArgs e)
        {
            while (true)
            {
                BackgroundWorker worker = sender as BackgroundWorker;
                Canvas _canvas          = (Canvas)e.Argument;

                switch (autonoma.estadoActual)
                {
                    case Accion.MOVERCE:
                        _canvas = Desplazar.Instancia.ejecutarAccionAutonomo(this);
                        break;

                    case Accion.RETIRADA:
                        _canvas = Retirada.Instancia.ejecutarAccionAutonomo(this);
                        break;

                    case Accion.ATACAR_DIRECTO:
                        _canvas = Atacar.Instancia.ejecutarAccionAutonomo(this);
                        break;
                }                
                
                Thread.Sleep(30);
            }  
        }        
    
       
        
        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
        }

        
        private void backgroundWorker1_ProgressChanged(object sender,ProgressChangedEventArgs e)
        {            
        }

        /// <summary>
        /// Método que corre el proceso
        /// </summary>
        private void correrProceso()
        {
            //while (true)
            {
                ServicioDibujar.dibujarLienzo(canvas);
            }
        }

        



        
    }
}
