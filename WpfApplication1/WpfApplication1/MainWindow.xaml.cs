using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using WpfApplication1.Informacion;

namespace WpfApplication1
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        /// <summary>
        /// control visual principal
        /// </summary>
        public ControlVisual controlVisual                 { get; set; }

        /// <summary>
        /// Control visual del lienzo
        /// </summary>
        public ControlVisualSimulacion controlVisualLienzo { get; set; }

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        public MainWindow()
        {
            InitializeComponent();

            //Inicia la propiedad del componente
            controlVisual       = new ControlVisual(this);

            //Inicia el control visual del lienzo
            controlVisualLienzo = new ControlVisualSimulacion(this);

            
        }

        public void establecerOperatividadAutonoma(Unidad unidad)
        {
            this.TablaUnidadAutonoma.ItemsSource = new List<Unidad>() { unidad };
        }
        
        /// <summary>
        /// Método que 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Button_Click(object sender, RoutedEventArgs e)
        {            
            controlVisual.obtenerInformacionDeArbol();
        }


        private void correr_simulacion(object sender, RoutedEventArgs e)
        {
            this.btnIniciar.IsEnabled = false;
            controlVisualLienzo.iniciarSimulacion();
        }

        private void bajando(object sender, KeyEventArgs e)
        {
            switch (e.Key)
            {
                case Key.Down:

                    controlVisualLienzo.enemiga.y+=5;
                    break;

                case Key.Up:
                    controlVisualLienzo.enemiga.y-=5;
                    break;

                case Key.Left:
                    controlVisualLienzo.enemiga.x-=5;
                    break;

                case Key.Right:
                    controlVisualLienzo.enemiga.x+=5;
                    break;
            }
            
           
        }
    }
}
