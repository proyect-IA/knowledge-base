using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using System.Windows.Threading;
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
        public Ellipse ia                         { get; set; }
        public Ellipse ene                        { get; set; }

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        public ControlVisualSimulacion(Canvas lienzo)
        {
            this.canvas = lienzo;
            
            ia        = new Ellipse();
            ia.Stroke = new SolidColorBrush(Colors.Blue);
            ia.Fill   = new SolidColorBrush(Colors.Blue);
            ia.Width  = 30;
            ia.Height = 30;

            ene        = new Ellipse();
            ene.Stroke = new SolidColorBrush(Colors.Red);
            ene.Fill   = new SolidColorBrush(Colors.Red);
            ene.Width  = 30;
            ene.Height = 30;
        }

        public void iniciarSimulacion()
        {
            backgroundWorker1 = new BackgroundWorker();
            
            InitializeBackgroundWorker();

            backgroundWorker1.RunWorkerAsync(canvas);
            //Creamos el delegado 
            //ThreadStart delegado = new ThreadStart(correrProceso);

            //Creamos la instancia del hilo 
            //Thread hilo          = new Thread(delegado);

            //Iniciamos el hilo 
            //hilo.Start();
        }

        // Set up the BackgroundWorker object by 
        // attaching event handlers. 
        private void InitializeBackgroundWorker()
        {
            backgroundWorker1.DoWork             += new DoWorkEventHandler(backgroundWorker1_DoWork);
            backgroundWorker1.RunWorkerCompleted += new RunWorkerCompletedEventHandler(backgroundWorker1_RunWorkerCompleted);
            backgroundWorker1.ProgressChanged    += new ProgressChangedEventHandler(backgroundWorker1_ProgressChanged);
        }

        // This event handler is where the actual,
        // potentially time-consuming work is done.
        private void backgroundWorker1_DoWork(object sender,DoWorkEventArgs e)
        {
            while (true)
            {
                BackgroundWorker worker = sender as BackgroundWorker;
                Canvas _canvas          = (Canvas)e.Argument;
                Application.Current.Dispatcher.BeginInvoke(DispatcherPriority.Background,new Action(()=>calcular(_canvas)));
                Thread.Sleep(500);
            }  
        }

        public void calcular(Canvas _canvas)
        {
            canvas.Children.Clear();
            double y  = canvas.ActualHeight;
            double x  = canvas.ActualWidth;

            Random rn = new Random();
            float xx  = rn.Next(1,(int)x);
            float yy  = rn.Next(1, (int)y);

            float xxx = rn.Next(1, (int)x);
            float yyy = rn.Next(1, (int)y);

            Canvas.SetLeft(ia, xx);
            Canvas.SetTop(ia, yy);

            Canvas.SetLeft(ene, xxx);
            Canvas.SetTop(ene, yyy);

            canvas.Children.Add(ia);
            canvas.Children.Add(ene);
        }
    
       
        
        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
        }

        // This event handler updates the progress bar.
        private void backgroundWorker1_ProgressChanged(object sender,ProgressChangedEventArgs e)
        {
            //this.progressBar1.Value = e.ProgressPercentage;
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
