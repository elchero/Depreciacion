<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Preguntas Frecuentes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Arial', sans-serif;
            }
            .container {
                max-width: 800px;
                margin-top: 50px;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.1);
            }
            .accordion-button {
                font-size: 1.2rem;
                font-weight: bold;
                background-color: #ffffff;
                color: #333333;
            }
            .accordion-button:focus {
                box-shadow: none;
                border-color: #333333;
            }
            .accordion-button:not(.collapsed) {
                background-color: #e9ecef;
                color: #000000;
            }
            .accordion-body {
                font-size: 1rem;
                line-height: 1.6;
                color: #555555;
            }
            .faq-header {
                font-size: 2rem;
                font-weight: bold;
                color: #333333;
                text-align: center;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <body>
        <jsp:include page="/nav/navbar.jsp"></jsp:include>
        <div class="container mt-5">
            <h1 class="mb-4">Preguntas Frecuentes</h1>
            <div class="accordion" id="faqAccordion">

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingOne">
                        <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                            ¿Qué es la depreciación de un activo?
                        </button>
                    </h2>
                    <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            En términos simples, la depreciación es la disminución gradual del valor de un activo tangible a lo largo de su vida útil. Un activo tangible es cualquier bien físico que una empresa posee y utiliza para generar ingresos, como maquinaria, equipos, vehículos o edificios.
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingTwo">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                            ¿Por qué se deprecia un activo?
                        </button>
                    </h2>
                    <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            <ul>
                                <li><strong>Desgaste:</strong> Con el uso, los activos se deterioran físicamente.</li>
                                <li><strong>Obsolescencia:</strong> La tecnología avanza y los activos pueden volverse obsoletos.</li>
                                <li><strong>Agotamiento:</strong> En el caso de recursos naturales, como minas o pozos petroleros, se agotan con el tiempo.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingThree">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                            ¿Cuál es la importancia de la depreciación?
                        </button>
                    </h2>
                    <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            <ul>
                                <li><strong>Reemplazo de activos:</strong> La depreciación permite a las empresas acumular fondos para reemplazar activos cuando alcancen el final de su vida útil.</li>
                                <li><strong>Decisiones de inversión:</strong> La depreciación influye en las decisiones de inversión, ya que las empresas pueden considerar la depreciación de activos existentes al evaluar la adquisición de nuevos.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingFour">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
                            ¿Cuál es la importancia de la depreciación a nivel contable?
                        </button>
                    </h2>
                    <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            <ul>
                                <li><strong>Reflejo de la realidad económica:</strong> La depreciación es un reconocimiento contable de la disminución del valor de un activo a lo largo del tiempo.</li>
                                <li><strong>Cálculo de la utilidad neta:</strong> La depreciación es un gasto que reduce la utilidad neta de una empresa.</li>
                                <li><strong>Información para toma de decisiones:</strong> Los estados financieros con información precisa sobre la depreciación proporcionan a los usuarios una imagen más clara de la situación financiera de la empresa.</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingFive">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive" aria-expanded="false" aria-controls="collapseFive">
                            ¿Qué es la amortización?
                        </button>
                    </h2>
                    <div id="collapseFive" class="accordion-collapse collapse" aria-labelledby="headingFive" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Es el proceso de asignar sistemáticamente el costo de un activo intangible a los períodos en los que se espera que genere beneficios económicos. A diferencia de los activos tangibles (que se deprecian), los activos intangibles carecen de una sustancia física, pero tienen un valor económico.
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingSix">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSix" aria-expanded="false" aria-controls="collapseSix">
                            ¿Qué son los activos intangibles?
                        </button>
                    </h2>
                    <div id="collapseSix" class="accordion-collapse collapse" aria-labelledby="headingSix" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Los activos intangibles son aquellos bienes que no tienen una existencia física, pero que generan beneficios económicos a la empresa. Algunos ejemplos son las patentes, marcas registradas, derechos de autor, licencias, y el fondo de comercio.
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingSeven">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSeven" aria-expanded="false" aria-controls="collapseSeven">
                            ¿Por qué se amortiza un activo intangible?
                        </button>
                    </h2>
                    <div id="collapseSeven" class="accordion-collapse collapse" aria-labelledby="headingSeven" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            Al igual que la depreciación, la amortización reconoce que los activos intangibles tienen una vida útil limitada. Con el tiempo, su valor económico puede disminuir debido a cambios en la tecnología, la competencia o las preferencias de los consumidores.
                        </div>
                    </div>
                </div>

                <div class="accordion-item">
                    <h2 class="accordion-header" id="headingEight">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseEight" aria-expanded="false" aria-controls="collapseEight">
                            ¿Cuál es la importancia de la amortización?
                        </button>
                    </h2>
                    <div id="collapseEight" class="accordion-collapse collapse" aria-labelledby="headingEight" data-bs-parent="#faqAccordion">
                        <div class="accordion-body">
                            <ul>
                                <li><strong>Reflejo contable:</strong> Al igual que la depreciación, la amortización es un gasto contable que reduce la utilidad neta y afecta el valor en libros de los activos.</li>
                                <li><strong>Decisiones de inversión:</strong> La amortización ayuda a las empresas a evaluar la rentabilidad de las inversiones en activos intangibles.</li>
                                <li><strong>Información para usuarios externos:</strong> Los estados financieros con información precisa sobre la amortización proporcionan a los inversores, acreedores y otros usuarios una imagen más clara de la situación financiera de la empresa.</li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
